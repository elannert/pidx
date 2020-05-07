from pdf2image import convert_from_path, convert_from_bytes
from pdf2image.exceptions import (
    PDFInfoNotInstalledError,
    PDFPageCountError,
    PDFSyntaxError
)

pdf_filename = 'ERD_LRS.pdf'
output_folder = 'accme_jpeg'

images = convert_from_path(pdf_filename, fmt='jpeg', output_folder=output_folder)

