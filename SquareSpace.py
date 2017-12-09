import fnmatch
import os
import re
"""
In order to use this script, you must first save each unique page from your SquareSpace website. You can do
this on a Mac by pressing command-s. 
Make sure you save each page in its own folder, aka save your "about" page
in a folder called "about". You don't need to worry about the name of the .html file itself.
Once you've saved each webpage to its own folder, put them all into a parent folder, and copy this script
to be in the same parent folder, and then execute it.

cd ~/parent_folder
python SquareSpace.py
"""
from bs4 import BeautifulSoup


def find(pattern, path):
    result = []
    for root, dirs, files in os.walk(path):
        for name in files:
            if fnmatch.fnmatch(name, pattern):
                result.append(os.path.join(root, name))
    return result


def question():
    print "What is your website called? Include the https://, please!"
    addr = raw_input().strip()
    addr = addr if addr[-1] is not "/" else addr[:-1]  # remove extra /
    print "What is the link to your favicon? give full url if not a local file. E.g. \"/images/favicon.png\"."
    icon = raw_input().strip()
    return addr, icon


class HTML:
    def __init__(self, page, url, favicon):
        self.page = page.read()
        self.favicon = favicon
        self.url = url

    def unblock(self):
        self.page = re.sub('(?<= ) ?data-ajax-loader="ajax-loader-binded"', "", self.page)

    def add_favicon(self):
        soup = BeautifulSoup(self.page, "html.parser")
        for link in soup.findAll("meta"):
            if "favicon" in str(link):
                self.page = self.page.replace(str(link['content']), self.favicon)

        for link in soup.findAll("link"):
            if "favicon" in str(link):
                self.page = self.page.replace(str(link['href']), self.favicon)

    def add_url(self):
        self.page = re.sub(self.find_user(), self.url, self.page)

    def find_user(self):
        soup = BeautifulSoup(self.page, "html.parser")
        links = soup.findAll("meta")
        for link in links:
            if "twitter:url" in str(link):
                return re.sub("(?<=com).*", "", str(link["content"]))  # cutoff any random shit


if __name__ == '__main__':
    _url, _favicon = question()
    indices = find('*.html', ".")  # specify path here if you don't want it to be the current directory
    for index in indices:
        with open(index, 'rb') as html:
            page = HTML(html, _url, _favicon)
            page.unblock()  # disable the blockers for page redirection
            page.add_url()
            page.add_favicon()  # replace the non-local favicon
        path = os.path.dirname(index) + "/index.html"
        os.system("rm {0}".format(index))
        with open(path, 'wb') as out_file:
            print "writing %s" % path
            out_file.write(page.page)
    print "done"
