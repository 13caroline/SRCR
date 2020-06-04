import pandas
import xlrd

def excelToCSV():

    workbook = xlrd.open_workbook("lista_adjacencias_paragens.xlsx")
    sheets = workbook.sheet_names()
    name = "carreiras/c_"
    for sheet in range(0, len(sheets)):
        sheet_name = sheets[sheet]
        csv_file = name + sheet_name + ".csv"
        file = pandas.read_excel("lista_adjacencias_paragens.xlsx", sheet_name)
        file.to_csv(csv_file, index = None, header=True)

excelToCSV()



