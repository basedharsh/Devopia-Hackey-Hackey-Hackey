from flask import Flask, jsonify
from PyPDF2 import PdfReader

app = Flask(__name__)

def extract_text_from_pdf(pdf_file_path):
    pdf_reader = PdfReader(pdf_file_path)
    num_pages = len(pdf_reader.pages)
    full_text = ''
    for page_num in range(num_pages):
        page = pdf_reader.pages[page_num]
        full_text += page.extract_text()
    return full_text


##########################################################################################################################################################################


@app.route('/pdfToText',methods=['GET'])
def treeEnumerationScript():
    pdf_text = extract_text_from_pdf('test.pdf')
    print(pdf_text)

    output ={}
    output["pdfText"] = pdf_text

    return jsonify(output)



##########################################################################################################################################################################



if __name__ == '__main__':
    app.run()