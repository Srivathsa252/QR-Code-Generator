# QR-Code-Generator
This is a simple, user-friendly QR Code generator built in Python. It takes a URL input from the user and generates a QR code accordingly. The QR code is saved as a .png image file.

This script generates a QR code for a given URL and saves it as "url_qrcode.png". 

## Features

- **User-friendly**: Easy to use, just requires running the script and entering a URL.
- **Customizable**: User can easily modify code to change QR code properties such as color, size, and border.
- **Error correction**: Uses error correction level L to ensure QR code remains readable even if it gets slightly damaged.

## Instructions

1. **Run the script**:
   ```python
   import qrcode

   # Prompt user for URL
   url = input("Enter the URL you want to generate a QR code for: ")

   # Generate QR code
   qr = qrcode.QRCode(
       version=1,
       error_correction=qrcode.constants.ERROR_CORRECT_L,
       box_size=10,
       border=4,
   )
   qr.add_data(url)
   qr.make(fit=True)

   # Create an image from the QR code
   img = qr.make_image(fill_color="black", back_color="white")

   # Save the image
   img.save("url_qrcode.png")

   print("QR code generated and saved as 'url_qrcode.png'. You can find it in the same directory as the script.")
