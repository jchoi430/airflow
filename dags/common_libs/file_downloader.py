import mechanize
import http.cookiejar
from collections import namedtuple


class FileDownloader:
    def __init__(self, base_url, login_fields_set: namedtuple):
        self.base_url = base_url
        self.login_fields_set = login_fields_set
        self.br = mechanize.Browser()
        self.cj = http.cookiejar.CookieJar()
    
    def _login(self) -> None: 
        self.br.set_cookiejar(self.cj)
        self.br.open(self.base_url)
        self.br.select_form(nr=0)
        for fields_set in self.login_fields_set:
            self.br.form[fields_set.field_tag] = fields_set.field_value
        self.br.submit()

    def download(self, file_url, dest_file):
        try:
            self._login()
            self.br.open(file_url)
            fileobj = open('temp/' + dest_file,"wb")
            fileobj.write(self.br.response().read())
            return 'temp/' + dest_file
        except Exception as e:
            print(e)
            return None
        finally:
            fileobj.close()
            self.br.close()
            self.cj.clear()
