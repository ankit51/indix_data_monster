
# coding: utf-8

# ## Import required libraries

# In[ ]:

import glob
import os.path
from bs4 import BeautifulSoup
import re
import pandas as pd
import urllib.request as ur


# ## Initialise variables

# In[ ]:

count = 0
y = []
dir_path = r"C:\Users\Ankit\Desktop\indix\HTMLPage-Classifier-Dataset\html_sample_dataset\am"


# ## Get all file names with titles

# In[ ]:

for file_name in glob.glob(os.path.join(dir_path, "*")):
    try:
        with open(file_name) as html_file:
            soup = BeautifulSoup(html_file, 'lxml')
            count = count + 1
            y.append([file_name.split('\\')[-1], soup('title')[0].text])
    except:
        pass


# In[ ]:

df = pd.DataFrame(y)


# In[ ]:

df.to_csv('all_page_titles.csv', encoding = 'utf-8')


# In[ ]:

df = pd.read_csv('all_page_titles.csv')


# ## Find Product Pages

# In[ ]:

def find_product(x):
    if re.findall('^Amazon.+', x) == []:
        return x


# In[ ]:

product_df = df[df['1'] == df['1'].apply(lambda x: find_product(x))]


# In[ ]:

product_df.to_csv('all_products.csv', encoding = 'utf-8')


# ## Find category for each product page

# In[ ]:

m = []
for file_name in os.path.join(dir_path, product_df['0']):
    with open(file_name) as html_file:
        soup = BeautifulSoup(html_file, 'lxml')
        m .append(soup('li')[0].get_text())
product_df['category'] = m


# In[ ]:

product_df.columns = ['file_name', 'product_name', 'category']
def strip_cat(x):
    if x == None:
        return None
    else:
        return x.strip()
product_df['category'] = product_df['category'].apply(lambda x: strip_cat(x))


# In[ ]:

df.to_csv('all_page_titles', encoding = 'utf-8', sep = '\t')


# ## Parse web pages in others category for title and header

# In[ ]:

other_pages = ['http://www.amazon.in/b/ref=footer_gw_m_b_corporate?ie=UTF8&node=1592138031',
              'http://amazon.jobs/',
              'http://www.amazon.in/b/ref=footer_press?ie=UTF8&node=1592137031',
              'http://www.amazon.in/b/ref=footer_cares?ie=UTF8&node=8872558031',
              'http://www.amazon.in/Online-Charity/b/ref=footer_smile?ie=UTF8&node=4594605031',
              'https://www.amazon.in/refer-and-earn/ref=footer_refer_earn',
              'http://services.amazon.in/services/sell-on-amazon/benefits.html/ref=az_footer_soa?ld=AWRGINSOAfooter',
              'https://www.amazon.in/gp/redirect.html/ref=footer_assoc?_encoding=UTF8&location=https%3A%2F%2Faffiliate-program.amazon.in%2F%3Futm_campaign%3Dassocshowcase%26utm_medium%3Dfooter%26utm_source%3DGW&source=standards&token=680FE811DE27E32BF3D5179FEDA69BDF16FC904C',
              'http://services.amazon.in/services/fulfilment-by-amazon/benefits.html/ref=az_footer_fba?ld=AWRGINFBAfooter',
              'https://paywithamazon.amazon.in/merchant?ld=Amz.in',
              'https://advertising.amazon.in/?ref=Amz.in',
              'http://www.amazon.in/gp/css/homepage.html/ref=footer_ya',
              'http://www.amazon.in/gp/css/returns/homepage.html/ref=footer_hy_f_4',
              'http://www.amazon.in/gp/help/customer/display.html/ref=footer_swc?ie=UTF8&nodeId=201083470',
              'http://www.alibaba.com/help?spm=a2700.7848340.0.0.LoCiaM&tracelog=footer_hp_buyer',
              'http://www.alibaba.com/help/contact-us.html?spm=a2700.7848340.0.0.LoCiaM#askquestion?tracelog=footercontact',
              'http://channel.alibaba.com/complaint/home.htm?spm=a2700.7848340.0.0.LoCiaM&tracelog=24581_foot_report_dispute',
              'http://activities.alibaba.com/alibaba/following-about-alibaba.php?spm=a2700.7848340.0.0.LoCiaM',
              'http://www.alibabagroup.com/en/global/home?spm=a2700.7848340.0.0.LoCiaM',
              'https://www.flipkart.com/about-us?otracker=undefined_footer_navlinks',
              'https://www.flipkart.com/s/contact?otracker=undefined_footer_navlinks',
              'https://www.flipkart.com/ol?link=http%3A%2F%2Fwww.flipkartcareers.com%2F&otracker=undefined_footer_navlinks',
              'https://seller.flipkart.com/?utm_source=flipkart&utm_medium=website&utm_campaign=sellbutton',
              'https://affiliate.flipkart.com/?otracker=undefined_footer_navlinks',
              'http://www.snapdeal.com/page/about-us',
              'https://career4.successfactors.com/career?company=Jasper',
              'http://www.snapdeal.com/page/terms',
              'http://sellers.snapdeal.com/',
              'https://ads.snapdeal.com/',
              'http://affiliate.snapdeal.com/',
              'http://www.snapdeal.com/faq/faqCustomerCare',
              'https://paytm.com/about-us/',
              'https://paytm.com/about-us/partner-with-us-2/',
              'https://paytm.com/about-us/opportunities/',
              'http://pages.ebay.in/ebayexplained/index.html',
              'http://pages.ebay.in/advertising/',
              'http://jobs.ebaycareers.com/']


# In[ ]:

for i in other_pages:
    html = ur.urlopen(i).read()
    soup = BeautifulSoup(html, 'lxml')
    try:
        print(i, ',', soup('title')[0].get_text())
        print(i, ',', soup('h1')[0].get_text())
    except:
        pass

