#coding=utf-8
from selenium import webdriver  #use selenium to imitate the crawler process
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.keys import Keys
import time  
import xlrd
import xlwt
import xlutils.copy
import socket
socket.setdefaulttimeout(100) #set timeout to 100s, to prevent process from running too long

def s(int):  
    time.sleep(int)
    
def getName(name,url,table):#get names of each professor's following people
    url = url+"/info"   #info web has more clear information
    browser.get(url)    #get to the url
    try:
        browser.find_element_by_class_name("ga-view-all-profile-followers").click()    #click the button to open the list of followers
        time.sleep(3)   #sleep 3s to wait for the click delay, in case the list doesn't open
        follower = browser.find_elements_by_class_name("display-name")  #find names of the followers
        global count
        for i in range(60):
            try:
                print(follower[i].text)
                count = count+1
                table.write(count,0, name)               #write names to excel
                table.write(count,1,follower[i].text)
            except:                                      #if there is some mistake(such as the number of names is less than 150), do not terminate and just ignore,
                return
    except:
        return

browser = webdriver.Chrome()                #open a chrome browser
browser.get('https://www.researchgate.net/login')  #get to login page
browser.find_element_by_id('input-login').send_keys(u'username') #input the username
browser.find_element_by_id('input-password').send_keys(u'password')  #input the password
browser.find_element_by_xpath("//form/button").click()  #click the button to login in
time.sleep(1)                               #sleep 1 time to wait for the network delay

data = xlrd.open_workbook('member_1.xlsx')  #open the excel of these people need to get their followers
table = data.sheets()[0]
rb = xlrd.open_workbook('follower_1.xls')   #open the excel of followers
wb = xlutils.copy.copy(rb)                  #continue to write instead of replacing
ws = wb.get_sheet(0)                        #get the sheet
count = 0
for i in range(table.nrows):                #go through all the rows
    name = table.col(0)[i].value            #get the name of the professor
    url_i = str(table.col(5)[i].value)      #get the homepage of the professor
    getName(name,url_i,ws)                  #get names of his followers
    wb.save('follower_1.xls')

