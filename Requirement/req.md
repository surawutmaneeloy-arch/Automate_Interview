เกี่ยวกับเว็บที่ทดสอบ
เครื่องคิดเลขมีช่อง First number, Second number, Operation (Add, Subtract, Multiply, Divide, Concatenate), checkbox “Integers only” ปุ่ม Calculate และ Clear
ด้านบนมี dropdown Build ให้เลือก Prototype และ Build 1–9 ให้ถือว่าแต่ละ build คือเวอร์ชันที่ developer ส่งมาให้ทดสอบ

ส่วนที่ 1: ออกแบบ Test Case 
เขียน test case ให้ครอบคลุมทุก operation และ checkbox “Integers only” โดยคำนึงถึง
•	ค่าปกติ (จำนวนบวก, ลบ, ศูนย์, ทศนิยม)
•	ค่าขอบเขตและกรณีพิเศษ
•	ค่าที่ไม่ถูกต้อง (negative test)
•	การทำงานของปุ่ม Clear
TC ID	Operation	First number	Second number	Integers only	Expected result	เทคนิค / เหตุผล
TC01	Add	2	3	No	5	ค่าปกติ
TC02						
TC03						


ส่วนที่ 2: เขียน Automate Test แบบ Data-driven 
1.	สร้างโปรเจกต์ใหม่และรันได้บนเครื่องตัวเอง
2.	เขียน test ชุดเดียวที่อ่านข้อมูลจากตาราง test case ในส่วนที่ 1 (array, CSV หรือ JSON)
3.	รันกับ Prototype ให้ผ่านทั้งหมด
4.	ปรับให้ build เป็น parameter แล้วรัน test ชุดเดิมกับ Build 1–9 โดยไม่ copy โค้ดซ้ำ
5.	เปิด report ผลการรันให้ดู
ข้อกำหนด
•	Expected result ต้องมาจากตารางข้อมูลหรือการคำนวณที่ถูกต้อง ไม่ใช่อ่านจากหน้าเว็บมาเทียบ
•	ห้ามใช้ hard wait (sleep / waitForTimeout)


ส่วนที่ 3: รายงานบั๊ก 
จากผลการรัน Build 1–9 สรุปบั๊กที่พบ
Build	อาการบั๊ก	Input	Expected	Actual	ความรุนแรง
1					
2					
3					

สิ่งที่ต้องส่ง
•	☐ ตาราง test case (ส่วนที่ 1)
•	☐ Source code (บีบอัดหรือลิงก์ Git)
•	☐ Report ผลการรัน
•	☐ ตารางสรุปบั๊ก (ส่วนที่ 3)
