package za.co.studyanything.maps;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Iterator;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ReadExcelFileToList {

    public static String readExcelData(String fileName) {
        
        StringBuilder allString = new StringBuilder();
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
            
            
            while (rowIterator.hasNext()) {


                //Get the row object
                Row row = rowIterator.next();

                //Every row has columns, get the column iterator and iterate over them
                Iterator<Cell> cellIterator = row.cellIterator();

                StringBuilder str = new StringBuilder();
                
                while (cellIterator.hasNext()) {
                    //Get the Cell object
                    Cell cell = cellIterator.next();
                    
                    
                    String thisVal;
                    double thisNumericVal;
                    
                    //check the cell type and process accordingly
                    switch (cell.getCellType()) {
                        case Cell.CELL_TYPE_STRING:
                            thisVal = cell.getStringCellValue().trim();
                            str.append(thisVal);
                            break;
                        case Cell.CELL_TYPE_NUMERIC:
                            thisNumericVal = cell.getNumericCellValue();
                            str.append(thisNumericVal);
                    }
                    if (cellIterator.hasNext())
                    {
                        str.append(",");
                    }
                    
                } //end of cell iterator
               
                allString.append(str);
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

        return allString.toString();
    }

}
