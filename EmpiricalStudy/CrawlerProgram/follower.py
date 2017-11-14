#coding=utf-8
from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains #引入ActionChains鼠标操作类  
from selenium.webdriver.common.keys import Keys #引入keys类操作  
import time  
import xlrd
import xlwt
import xlutils.copy
import socket
socket.setdefaulttimeout(100)

def s(int):  
    time.sleep(int)
    
def getName(name,url,table):
    url = url+"/info"
    browser.get(url)
    try:
        browser.find_element_by_class_name("ga-view-all-profile-followers").click()    
        time.sleep(3)
        follower = browser.find_elements_by_class_name("display-name")
        global count
        for i in range(60):
            try:
                print(follower[i].text)
                count = count+1
                table.write(count,0, name)
                table.write(count,1,follower[i].text)
            except:
                return
    except:
        return

browser = webdriver.Chrome()  
browser.get('https://www.researchgate.net/login')  
browser.find_element_by_id('input-login').send_keys(u'zfone@buaa.edu.cn')  
browser.find_element_by_id('input-password').send_keys(u'zfone533210') 
browser.find_element_by_xpath("//form/button").click()
time.sleep(1)

data = xlrd.open_workbook('member_1.xlsx')
table = data.sheets()[0]
rb = xlrd.open_workbook('follower_1.xls')
wb = xlutils.copy.copy(rb)
#获取sheet对象，通过sheet_by_index()获取的sheet对象没有write()方法
ws = wb.get_sheet(0)
count = 0
for i in range(table.nrows):
    name = table.col(0)[i].value
    url_i = str(table.col(5)[i].value)
    getName(name,url_i,ws)
    wb.save('follower_1.xls')

