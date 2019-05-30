package za.co.studyanything.maps;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import org.slf4j.LoggerFactory;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class FileUploadController {
    
    private static final String VIEW_INDEX = "index";
    
    private final static org.slf4j.Logger logger = LoggerFactory.getLogger(FileUploadController.class);

    
    @RequestMapping(value="/upload", method=RequestMethod.POST)
    public @ResponseBody String handleFileUpload(ModelMap model, @RequestParam("file") MultipartFile file){
        
        logger.debug("Uploading file");
        if (!file.isEmpty()) {
            
            try {
                
                byte[] bytes = file.getBytes();
                BufferedOutputStream stream = 
                        new BufferedOutputStream(new FileOutputStream(new File(file.getOriginalFilename())));
                stream.write(bytes);
                stream.close();
                
                ReadExcelFileToList reader = new ReadExcelFileToList();
                String fileContents = reader.readExcelData(file.getOriginalFilename());
                logger.debug(fileContents);

                return fileContents;
            } catch (Exception e) {
                return "You failed to upload " + file.getOriginalFilename() + " => " + e.getMessage();
            }
        } else {
            return "You failed to upload " + file.getOriginalFilename() + " because the file was empty.";
        }
    }
    
}
