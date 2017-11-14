#coding=utf-8
from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains #引入ActionChains鼠标操作类  
from selenium.webdriver.common.keys import Keys #引入keys类操作  
import time  
import xlrd
import xlwt
import xlutils.copy
import socket
import string
socket.setdefaulttimeout(100)

def s(int):  
    time.sleep(int)

def getInfo(proname, url,table):
    try:
        browser.get(url)
        browser.find_element_by_class_name("ga-top-coauthors-view-all").click()
        time.sleep(3)
    except:
        return
    global count
    #get information
    for i in range(50):
        st = "//ul/li["+str(i+1)+"]"+"[@class='nova-e-list__item']"
        #print(st)
        try:
            person = browser.find_element_by_xpath(st)
        except:
            return
        if "Not" in person.text:
            break
        sp = person.text.split("\n",2)
        if (len(sp)==1):
            continue
        name = sp[0]
        sp1 = sp[1].split("(",1)
        sp2 = sp1[1].split(")",1)
        score = sp1[0]
        pub = sp2[0]
        school = sp2[1]
        count += 1
        table.write(count,0, proname)
        table.write(count,1, name)
        table.write(count,2, score)
        table.write(count,3, pub)
        table.write(count,4, school)

def getName(proname, url,table):
    try:
        browser.get(url)
        browser.find_element_by_class_name("ga-top-coauthors-view-all").click()
        time.sleep(5)
    except:
        print("not find")
        return
    global count
    #get Name
    person = browser.find_elements_by_class_name('nova-v-person-list-item__title--clamp-1')
    time.sleep(3)
    paper = browser.find_elements_by_class_name('profile-coauthors-account-item__shared-publications')
    for i in range(50):
        try:
            name = person[i].text
            num = paper[i].text
            if ((name == person[0].text)&(i != 0)):
                return
            print(num)
            num = num.replace("(", "")
            num = num.replace(")", "")
            print(num)
            count += 1
            table.write(count,0, proname)
            table.write(count,1, name) 
            table.write(count,2,num)
        except:
            return

browser = webdriver.Chrome()  
browser.get('https://www.researchgate.net/login')  
browser.find_element_by_id('input-login').send_keys(u'14041153@buaa.edu.cn')
browser.find_element_by_id('input-password').send_keys(u'a19960810')
browser.find_element_by_xpath("//form/button").click()
time.sleep(1)
data = xlrd.open_workbook('core_member.xlsx')
table = data.sheets()[0]
#proname = table.col_values(0)
#url = table.col_values(4)
rb = xlrd.open_workbook('co-author.xls') 
wb = xlutils.copy.copy(rb)
#获取sheet对象，通过sheet_by_index()获取的sheet对象没有write()方法
ws = wb.get_sheet(0)
count = 0
nrows = table.nrows
for i in range(nrows):
    name = table.col(0)[i].value
    url_i = str(table.col(5)[i].value)
    getName(name,url_i,ws)
    wb.save('co-author.xls')
