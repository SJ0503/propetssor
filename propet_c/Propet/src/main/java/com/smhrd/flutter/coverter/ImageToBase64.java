package com.smhrd.flutter.coverter;

import java.io.File;
import java.io.IOException;
import java.util.Base64;

import org.apache.commons.io.FileUtils;

public class ImageToBase64 {

	//매개인자 :File , 반환 타입 :String(base64 형식으로 인코딩된 값)
	public String convert(File file) throws IOException {
		//commons-io
		//File -> ByteArray
		byte[] fileArr = FileUtils.readFileToByteArray(file);
		String base64Str = Base64.getEncoder().encodeToString(fileArr);
	
		return base64Str;
	}
}
