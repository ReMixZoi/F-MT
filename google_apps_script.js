// ===========================================================
// Google Apps Script - วางโค้ดนี้ใน Google Apps Script Editor
// ===========================================================
// วิธีใช้:
// 1. เปิด Google Sheet ที่ต้องการเก็บข้อมูล
// 2. ไปที่ Extensions > Apps Script
// 3. วางโค้ดนี้ลงไป
// 4. Deploy > New deployment > Web app
//    - Execute as: Me
//    - Who has access: Anyone
// 5. คัดลอก URL ที่ได้ไปใส่ในแอป
// ===========================================================

function doPost(e) {
    try {
        var ss = SpreadsheetApp.getActiveSpreadsheet();
        var data = JSON.parse(e.postData.contents);

        // ตรวจสอบว่าเป็นข้อมูล Access Log หรือไม่
        if (data.type === 'access_log') {
            var logSheet = ss.getSheetByName('AccessLogs');
            // ถ้ายังไม่มี Sheet 'AccessLogs' ให้สร้างใหม่
            if (!logSheet) {
                logSheet = ss.insertSheet('AccessLogs');
                logSheet.appendRow(['วันที่', 'เวลา', 'ชื่อผู้ใช้', 'การกระทำ']); // Header
            }
            // บันทึก Log
            logSheet.appendRow([
                data.date,
                data.time,
                data.username,
                'เข้าใช้งานแอป'
            ]);
        } else {
            // โค้ดเดิมสำหรับบันทึกข้อมูลหลัก (ใช้ Sheet แรกเสมอเพื่อความชัวร์)
            var sheet = ss.getSheets()[0];

            // ถ้ายังไม่มี Header ให้สร้าง
            if (sheet.getLastRow() === 0) {
                sheet.appendRow(['ชื่อผู้ใช้', 'แอป', 'เนื้อหาที่ดู', 'ระยะเวลา (นาที)', 'วันที่', 'เวลา', 'หมายเหตุ']);
            }

            // เพิ่มข้อมูล
            sheet.appendRow([
                data.username,
                data.app,
                data.content,
                data.duration,
                data.date,
                data.time,
                data.note || ''
            ]);
        }

        return ContentService
            .createTextOutput(JSON.stringify({ status: 'success', message: 'บันทึกสำเร็จ' }))
            .setMimeType(ContentService.MimeType.JSON);
    } catch (error) {
        return ContentService
            .createTextOutput(JSON.stringify({ status: 'error', message: error.toString() }))
            .setMimeType(ContentService.MimeType.JSON);
    }
}

function doGet(e) {
    return ContentService
        .createTextOutput(JSON.stringify({ status: 'ok', message: 'App Usage Tracker API is running' }))
        .setMimeType(ContentService.MimeType.JSON);
}
