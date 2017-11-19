#coding=utf-8
from selenium import webdriver              #use selenium to imitate the crawler process
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.keys import Keys
import time  
import xlrd
import xlwt
import xlutils.copy
import socket
import string
socket.setdefaulttimeout(100)

def getInfo(proname, url,table):  #get the specific information of the co-authors
    try:                          #try to get to the homepage of each professor, and click the button to view their co-authors
        browser.get(url)
        browser.find_element_by_class_name("ga-top-coauthors-view-all").click()
        time.sleep(3)
    except:
        return
    global count
    #get information
    for i in range(50):
        st = "//ul/li["+str(i+1)+"]"+"[@class='nova-e-list__item']"    #use xpath to locate the information of co-authors
        try:
            person = browser.find_element_by_xpath(st)
        except:
            return
        if "Not" in person.text:                                       #not means the co-author has no researchgate account
            break
        sp = person.text.split("\n",2)                                 #split the information
        if (len(sp)==1):                                               #if there is nothing, skip
            continue
        name = sp[0]                                                   #name
        sp1 = sp[1].split("(",1)                                       #score
        sp2 = sp1[1].split(")",1)                                      #publication
        score = sp1[0]
        pub = sp2[0]
        school = sp2[1]                                                #school
        count += 1
        table.write(count,0, proname)                                  #write the information to excel
        table.write(count,1, name)
        table.write(count,2, score)
        table.write(count,3, pub)
        table.write(count,4, school)

def getName(proname, url,table):                                        #get names of these professors' co-authors
    try:
        browser.get(url)                                                            #get to the homepage of the professor
        browser.find_element_by_class_name("ga-top-coauthors-view-all").click()     #click the button to open the list of co-authors
        time.sleep(5)
    except:
        print("not find")
        return
    global count
    #get Name
    person = browser.find_elements_by_class_name('nova-v-person-list-item__title--clamp-1')             #use the classname to locate the name
    time.sleep(3)
    paper = browser.find_elements_by_class_name('profile-coauthors-account-item__shared-publications')  #use the classname to locate the paper
    for i in range(50):
        try:
            name = person[i].text                       #get the name of the co-author
            num = paper[i].text                         #get the number of papers they cooperate
            if ((name == person[0].text)&(i != 0)):
                return
            print(num)
            num = num.replace("(", "")                  #remove he bracket of the number of papers
            num = num.replace(")", "")
            print(num)
            count += 1
            table.write(count,0, proname)               #write the name and the number to the excel
            table.write(count,1, name) 
            table.write(count,2,num)
        except:
            return

browser = webdriver.Chrome()                                             #open a chrome browser
browser.get('https://www.researchgate.net/login')                        #get to the login page
browser.find_element_by_id('input-login').send_keys(u'username')         #input username
browser.find_element_by_id('input-password').send_keys(u'password')      #input password
browser.find_element_by_xpath("//form/button").click()                   #click the button to log in
time.sleep(1)
data = xlrd.open_workbook('core_member.xlsx')                           #open the excel of core members
table = data.sheets()[0]
rb = xlrd.open_workbook('co-author.xls')                                #open the excel of co-authors
wb = xlutils.copy.copy(rb)                                              #continue to write instead of replacing
ws = wb.get_sheet(0)                                                    #get the sheet to write
count = 0
nrows = table.nrows
for i in range(nrows):                                                  #go through all the rows
    name = table.col(0)[i].value                                        #get the name of the professor
    url_i = str(table.col(5)[i].value)                                  #get the homepage of the professor
    getName(name,url_i,ws)                                              #get names and number of paper of the professor's co-authors
    wb.save('co-author.xls')
