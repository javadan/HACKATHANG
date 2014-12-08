package za.co.studyanything.maps;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.LoggerFactory;

public class ReadExcelFileToList {

    private final static org.slf4j.Logger logger = LoggerFactory.getLogger(ReadExcelFileToList.class);
    
    public static String readExcelData(String fileName) {
        
        int numRecs = 0;
        StringBuilder allString = new StringBuilder();
        
        allString.append("{\"rows\": [");
  
        
        try {
            
            //Create the input stream from the xlsx/xls file
            FileInputStream fis = new FileInputStream(fileName);

            //Create Workbook instance for xlsx/xls file input stream
            Workbook workbook = null;
            if (fileName.toLowerCase().endsWith("xlsx")) {
                workbook = new XSSFWorkbook(fis);
            } else if (fileName.toLowerCase().endsWith("xls")) {
                workbook = new HSSFWorkbook(fis);
            }

            //Get the number of sheets in the xlsx file
            //int numberOfSheets = workbook.getNumberOfSheets();

            //Get the nth sheet from the workbook
            Sheet sheet = workbook.getSheetAt(0);

            //every sheet has rows, iterate over them
            Iterator<Row> rowIterator = sheet.iterator();

            
            //go through once and put headers in an array list
            ArrayList<String> headers = new ArrayList<String>();
            String thisVal;
            double thisNumericVal;
            if (rowIterator.hasNext())
            {
                Row row = rowIterator.next();
                Iterator<Cell> cellIterator = row.cellIterator();
                while (cellIterator.hasNext()) {
                    Cell cell = cellIterator.next();
                    switch (cell.getCellType()) {
                            case Cell.CELL_TYPE_STRING:
                                thisVal = cell.getStringCellValue().trim();
                                headers.add(thisVal);
                                break;
                        }
                }
            }
            
            for (String header : headers)
            {
                logger.debug(header);
            }
            
            //go through data, converting to json as you go.
            while (rowIterator.hasNext()) {

                numRecs++;

                allString.append("{");
                //Get the row object
                Row row = rowIterator.next();

                //Every row has columns, get the column iterator and iterate over them
                Iterator<Cell> cellIterator = row.cellIterator();

                StringBuilder str = new StringBuilder();
                
                String idString = "";
                //id column first
                if (cellIterator.hasNext())
                {
                    Cell cell = cellIterator.next();
                     switch (cell.getCellType()) {
                        case Cell.CELL_TYPE_STRING:
                            thisVal = cell.getStringCellValue().trim();
                            idString = "\"id\":\"" + thisVal + "\"";
                            break;
                        case Cell.CELL_TYPE_NUMERIC:
                            thisNumericVal = cell.getNumericCellValue();
                            idString = "\"id\":\"" + thisNumericVal + "\"";
                    }
                }
                  
                str.append(idString + ", \"cell\": {" + idString + ",");
                
                int cellCount = 1;
                while (cellIterator.hasNext()) {
                     Cell cell = cellIterator.next();
                     
                     switch (cell.getCellType()) {
                        case Cell.CELL_TYPE_STRING:
                            thisVal = cell.getStringCellValue().trim();
                            str.append("\"" + headers.get(cellCount)+  "\":\"" + thisVal + "\"");
                            break;
                        case Cell.CELL_TYPE_NUMERIC:
                            thisNumericVal = cell.getNumericCellValue();
                            str.append("\"" + headers.get(cellCount)+  "\":\"" + thisNumericVal + "\"");
                    }
                     
                    if (cellIterator.hasNext())
                    {
                        str.append(",");
                    }
                    
                    cellCount++;
                    
                } //end of cell iterator
               
                allString.append(str);
                allString.append("}}");

                if (rowIterator.hasNext())
                   {
                       allString.append(",");
                   }
            } //end of rows iterator

            //close file input stream
            fis.close();

        } catch (IOException e) {
            e.printStackTrace();
        }

        allString.append("]");
        allString.append(",\"total\":").append(numRecs);
        allString.append(",");
        allString.append("\"page\":").append(1);
        allString.append("}");
        return allString.toString();
    }
    
    
    
    
    /*
    {
  "page": 1,
  "total": 239,
  "rows": [
    {
      "id": "ZW",
      "cell": {
        "name": "Zimbabwe ",
        "iso": "ZW",
        "printable_name": "Zimbabwe ",
        "iso3": "ZWE ",
        "numcode": "716"
      }
    },
    {
      "id": "ZM",
      "cell": {
        "name": "Zambia ",
        "iso": "ZM",
        "printable_name": "Zambia ",
        "iso3": "ZMB ",
        "numcode": "894"
      }
    },
    {
      "id": "YE",
      "cell": {
        "name": "Yemen ",
        "iso": "YE",
        "printable_name": "Yemen ",
        "iso3": "YEM ",
        "numcode": "887"
      }
    },
    {
      "id": "EH",
      "cell": {
        "name": "Western Sahara ",
        "iso": "EH",
        "printable_name": "Western Sahara ",
        "iso3": "ESH ",
        "numcode": "732"
      }
    },
    {
      "id": "WF",
      "cell": {
        "name": "Wallis and Futuna ",
        "iso": "WF",
        "printable_name": "Wallis and Futuna ",
        "iso3": "WLF ",
        "numcode": "876"
      }
    },
    {
      "id": "VI",
      "cell": {
        "name": "Virgin Islands, U.s. ",
        "iso": "VI",
        "printable_name": "Virgin Islands, U.s. ",
        "iso3": "VIR ",
        "numcode": "850"
      }
    },
    {
      "id": "VG",
      "cell": {
        "name": "Virgin Islands, British ",
        "iso": "VG",
        "printable_name": "Virgin Islands, British ",
        "iso3": "VGB ",
        "numcode": "92"
      }
    },
    {
      "id": "VN",
      "cell": {
        "name": "Viet Nam ",
        "iso": "VN",
        "printable_name": "Viet Nam ",
        "iso3": "VNM ",
        "numcode": "704"
      }
    },
    {
      "id": "VE",
      "cell": {
        "name": "Venezuela ",
        "iso": "VE",
        "printable_name": "Venezuela ",
        "iso3": "VEN ",
        "numcode": "862"
      }
    },
    {
      "id": "VU",
      "cell": {
        "name": "Vanuatu ",
        "iso": "VU",
        "printable_name": "Vanuatu ",
        "iso3": "VUT ",
        "numcode": "548"
      }
    }
  ],
  "post": [

  ]
}

    */
}
