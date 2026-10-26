/* Offline ARM tests for real libc contracts needed by the bundled Cronet. */
#include <dlfcn.h>
#include <errno.h>
#include <limits.h>
#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

extern "C" char* __gnu_strerror_r(int, char*, size_t);
extern "C" ssize_t __pread_chk(int, void*, size_t, off_t, size_t);
extern "C" int __register_atfork(void (*)(void), void (*)(void), void (*)(void), void*);
extern "C" int __cxa_atexit(void (*)(void*), void*, void*);
extern "C" void __cxa_finalize(void*);
#define CHECK(x) do { if (!(x)) { fprintf(stderr,"FAIL line %d: %s (errno %d)\n",__LINE__,#x,errno); exit(1); } } while (0)

static int prepare_order, parent_order, child_order, destructors;
static void prepare_a() { prepare_order=prepare_order*10+1; }
static void parent_a() { parent_order=parent_order*10+1; }
static void child_a() { child_order=child_order*10+1; }
static void prepare_b() { prepare_order=prepare_order*10+2; }
static void parent_b() { parent_order=parent_order*10+2; }
static void child_b() { child_order=child_order*10+2; }
static void prepare_legacy() { prepare_order=prepare_order*10+3; }
static void parent_legacy() { parent_order=parent_order*10+3; }
static void child_legacy() { child_order=child_order*10+3; }
static void destructor(void*) { ++destructors; }

static void check_fork(int expected_prepare, int expected_callbacks) {
    prepare_order=parent_order=child_order=0;
    pid_t pid=fork();
    CHECK(pid>=0);
    if (!pid) _exit(prepare_order==expected_prepare && child_order==expected_callbacks ? 0 : 2);
    int status=0;
    CHECK(waitpid(pid,&status,0)==pid);
    CHECK(WIFEXITED(status) && WEXITSTATUS(status)==0);
    CHECK(prepare_order==expected_prepare && parent_order==expected_callbacks);
    CHECK(child_order==0);
}

int main() {
    char text[128];
    errno=E2BIG;
    CHECK(__gnu_strerror_r(EINVAL,text,sizeof(text))==text);
    CHECK(!strcmp(text,strerror(EINVAL)) && errno==E2BIG);
    errno=E2BIG;
    CHECK(__gnu_strerror_r(EINVAL,text,1)==text && text[0]=='\0' && errno==E2BIG);
    CHECK(__gnu_strerror_r(-1,text,sizeof(text))==text && strstr(text,"-1"));
    CHECK(errno==E2BIG);
    puts("PASS GNU strerror return, truncation, invalid code and errno");

    char path[]="/tmp/k7-cm12-libc-XXXXXX";
    int fd=mkstemp(path); CHECK(fd>=0); CHECK(unlink(path)==0);
    CHECK(write(fd,"abcdef",6)==6 && lseek(fd,3,SEEK_SET)==3);
    char data[4]={0};
    CHECK(__pread_chk(fd,data,3,1,sizeof(data))==3 && !strcmp(data,"bcd"));
    CHECK(lseek(fd,0,SEEK_CUR)==3);
    errno=0; CHECK(__pread_chk(-1,data,1,0,sizeof(data))==-1 && errno==EBADF);
    for (int i=0;i<2;++i) {
        pid_t pid=fork();CHECK(pid>=0);
        if (!pid) {
            if (!i) __pread_chk(fd,data,2,0,1);
            else __pread_chk(fd,data,static_cast<size_t>(SSIZE_MAX)+1,0,static_cast<size_t>(-1));
            _exit(3);
        }
        int status=0;CHECK(waitpid(pid,&status,0)==pid);
        CHECK(WIFSIGNALED(status) && WTERMSIG(status)==SIGABRT);
    }
    CHECK(close(fd)==0);
    puts("PASS fortified pread content, unchanged file offset, errno and both overflow aborts");

    int dso_a=0,dso_b=0;
    CHECK(__register_atfork(prepare_a,parent_a,child_a,&dso_a)==0);
    CHECK(__register_atfork(prepare_b,parent_b,child_b,&dso_b)==0);
    CHECK(__cxa_atexit(destructor,NULL,&dso_a)==0);
    CHECK(__cxa_atexit(destructor,NULL,&dso_b)==0);
    check_fork(21,12);
    __cxa_finalize(&dso_a); CHECK(destructors==1); check_fork(2,2);
    __cxa_finalize(&dso_b); CHECK(destructors==2); check_fork(0,0);
    CHECK(pthread_atfork(prepare_legacy,parent_legacy,child_legacy)==0);
    check_fork(3,3);
    puts("PASS fork callback order, selective DSO finalize/unregister and legacy pthread_atfork");

    void* cronet=dlopen("/system/priv-app/GmsCore/lib/arm/libcronet.102.0.5005.125.so",RTLD_NOW);
    if (!cronet) fprintf(stderr,"Cronet dlopen: %s\n",dlerror());
    CHECK(cronet!=NULL);
    CHECK(dlsym(cronet,"JNI_OnLoad")!=NULL);
    CHECK(dlclose(cronet)==0);
    check_fork(3,3);
    puts("PASS actual bundled Cronet load, JNI export, unload and subsequent fork");
    return 0;
}
