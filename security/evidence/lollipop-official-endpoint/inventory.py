from pathlib import Path
from html.parser import HTMLParser
from concurrent.futures import ThreadPoolExecutor
import urllib.request,json,re,hashlib
D=Path(__file__).resolve().parent
class Tables(HTMLParser):
 def __init__(self):super().__init__();self.row=None;self.cell=None;self.rows=[];self.links=[];self.heading=None;self.htext='';self.group='';self.component=''
 def handle_starttag(self,t,a):
  if t in ('h2','h3'):self.heading=t;self.htext=''
  if t=='tr':self.row=[];self.links=[]
  if t in ('td','th') and self.row is not None:self.cell=''
  if t=='a' and self.row is not None:
   href=dict(a).get('href','')
   if href:self.links.append(href)
 def handle_data(self,s):
  if self.heading:self.htext+=s
  if self.cell is not None:self.cell+=s
 def handle_endtag(self,t):
  if t==self.heading:
   if t=='h2':self.group=' '.join(self.htext.split())
   else:self.component=' '.join(self.htext.split())
   self.heading=None
  if t in ('td','th') and self.cell is not None:self.row.append(' '.join(self.cell.split()));self.cell=None
  if t=='tr' and self.row is not None:
   if self.row and re.search(r'CVE-\d{4}-\d+',self.row[0]):self.rows.append({'cells':self.row,'links':self.links,'group':self.group,'component':self.component})
   self.row=None
months=[f'{y}-{m:02d}' for y in range(2016,2019) for m in range(1,13) if '2016-11'<=f'{y}-{m:02d}'<='2018-03']
def fetch(month):
 u='https://source.android.com/docs/security/bulletin/'+month+'-01';b=urllib.request.urlopen(u,timeout=40).read();p=Tables();p.feed(b.decode());assert p.rows,(month,'no CVE rows');return month,{'url':u,'html_sha256':hashlib.sha256(b).hexdigest(),'rows':p.rows}
results={}
with ThreadPoolExecutor(max_workers=4) as ex:
 for month,result in ex.map(fetch,months):results[month]=result;print(month,len(result['rows']),flush=True)
(D/'bulletin-inventory.json').write_text(json.dumps(results,indent=2)+'\n')
explicit=[]
for month,result in results.items():
 for row in result['rows']:
  if any(re.search(r'(?<![\d.])5\.1\.1(?![\d.])',c) for c in row['cells']):explicit.append({'month':month,**row})
(D/'explicit-5.1.1-candidates.json').write_text(json.dumps(explicit,indent=2)+'\n')
print('Monthly bulletins:',len(results),'CVE rows:',sum(len(x['rows']) for x in results.values()),'Explicit 5.1.1 candidate rows:',len(explicit))
