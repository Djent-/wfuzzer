import sys

# Python 2 and 3
if sys.version_info >= (3,0):
  from urllib.parse import urljoin
else:
  from urlparse import urljoin
import json

from wfuzz.plugin_api.mixins import DiscoveryPluginMixin
from wufzz.plugin_api.base import BasePlugin
from wfuzz.externals.moduleman.plugin import moduleman_plugin

@moduleman_plugin
class elasticsearch(BasePlugin, DiscoveryPluginMixin):
  name = 'elasticsearch'
  author = ('Github: @Djent-, Twitter: @phurd_',)
  version = '0.1'
  summary = 'Parses _stats and _search for Elasticsearch'
  description = ('Parses _stats and _search for Elasticsearch')
  category = ['active', 'discovery']
  priority = 99
  
  parameters = ()
  
  def __init__(self):
    BasePlugin.__init__(self)
    
  def validate(self, fuzzresult):
    content_type = None
    headers = ['Content-Type', 'content-type']
    for h in headers:
      if h in fuzzresult.history.headers.response:
        content_type = fuzzresult.history.headers.response[h]
        break
    
    return not content_type or (
      fuzzresult.history.urlparse.ffname == '_stats'
      and fuzzresult.code == 200
      and 'application/json' in content_type
    ) or (
      fuzzresult.history.urlparse.ffname == '_search'
      and fuzzresult.code == 200
      and 'application/json' in content_type
    )
  
  def process(self, fuzzresult):
    data = fuzzresult.history.content
    j = json.loads(data)
    
    if 'indices' in j:
      self.add_result('elasticsearch', 'Indices found', str(len(j['indices'].keys())), severity=5)
      for i in j['indices'].keys():
        self.add_result('elasticsearch', 'Index:', i)
        new_link = urljoin(fuzzresult.url, f'{i}/_search')
        self.queue_url(new_link)
    
    if 'hits' in j:
      self.add_result('elasticsearch', 'Hits found (search results)', str(len(j['hits'])), severity=5)
      
# vim: tabstop=4 softtabstop=4
