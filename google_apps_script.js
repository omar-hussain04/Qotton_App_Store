function doPost(e) {
  var sheet = SpreadsheetApp.getActiveSpreadsheet();
  
  try {
    var data = JSON.parse(e.postData.contents);
    
    if (data.action === "addUser") {
      var usersSheet = sheet.getSheetByName("Users") || sheet.insertSheet("Users");
      
      // Keep headers if new
      if (usersSheet.getLastRow() === 0) {
        usersSheet.appendRow(["Date", "Name", "Email", "Phone"]);
      }
      
      usersSheet.appendRow([data.date, data.name, data.email, data.phone]);
      return ContentService.createTextOutput(JSON.stringify({"status": "success"})).setMimeType(ContentService.MimeType.JSON);
      
    } else if (data.action === "updateUser") {
      // Update Users Sheet
      var usersSheetUpdate = sheet.getSheetByName("Users");
      if (usersSheetUpdate) {
        var dataRange = usersSheetUpdate.getDataRange();
        var values = dataRange.getValues();
        
        for (var i = 1; i < values.length; i++) {
          if (values[i][2] === data.email) {
            usersSheetUpdate.getRange(i + 1, 2).setValue(data.name);
            usersSheetUpdate.getRange(i + 1, 4).setValue(data.phone);
            break; // Stop looking in Users once found
          }
        }
      }

      // Update Orders Sheet
      var ordersSheet = sheet.getSheetByName("Orders");
      if (ordersSheet) {
        var orderData = ordersSheet.getDataRange();
        var orderValues = orderData.getValues();

        for (var j = 1; j < orderValues.length; j++) {
          if (orderValues[j][2] === data.email) {
            ordersSheet.getRange(j + 1, 2).setValue(data.name);
            ordersSheet.getRange(j + 1, 4).setValue(data.phone);
          }
        }
      }

      return ContentService.createTextOutput(JSON.stringify({"status": "success"})).setMimeType(ContentService.MimeType.JSON);


    } else if (data.action === "addOrder") {
      var ordersSheet = sheet.getSheetByName("Orders") || sheet.insertSheet("Orders");
      
      // Keep headers if new
      if (ordersSheet.getLastRow() === 0) {
        ordersSheet.appendRow(["Date", "Name", "Email", "Phone", "Location", "Items", "Total ($)"]);
      }
      
      ordersSheet.appendRow([data.date, data.name, data.email, data.phone, data.location, data.items, data.total]);
      return ContentService.createTextOutput(JSON.stringify({"status": "success"})).setMimeType(ContentService.MimeType.JSON);
    }
    
    return ContentService.createTextOutput(JSON.stringify({"status": "error", "message": "Unknown action"})).setMimeType(ContentService.MimeType.JSON);

  } catch (error) {
    return ContentService.createTextOutput(JSON.stringify({"status": "error", "message": error.toString()})).setMimeType(ContentService.MimeType.JSON);
  }
}
