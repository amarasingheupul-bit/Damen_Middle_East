codeunit 50106 "Excel Import Mngmnt General"
{

    procedure ImportFromExcel()
    var
        ExcelDataImport: Record "Excel Data Import General";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        InStream: InStream;
        FromFile: Text;
        SheetName: Text;
        RowNo: Integer;
        TotalRows: Integer;
        I: Integer;
    begin
        if not UploadIntoStream('Import Excel File', '', 'Excel Files (*.xlsx)|*.xlsx', FromFile, InStream) then
            exit;

        SheetName := TempExcelBuffer.SelectSheetsNameStream(InStream);
        if SheetName = '' then
            exit;

        Clear(I);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(InStream, SheetName);
        TempExcelBuffer.ReadSheet();

        if TempExcelBuffer.FindLast() then
            TotalRows := TempExcelBuffer."Row No." - 1;
        if TotalRows = 0 then
            Error('No data found in Excel file');

        for RowNo := 2 to TotalRows + 1 do begin
            ExcelDataImport.Init();
            ExcelDataImport."Entry No." += 1;
            if this.GetValueAtCell(TempExcelBuffer, RowNo, 1) <> '' then
                ExcelDataImport."Document No." := CopyStr(this.GetValueAtCell(TempExcelBuffer, RowNo, 1), 1, MaxStrLen(ExcelDataImport."Document No."));

            if this.GetValueAtCell(TempExcelBuffer, RowNo, 2) <> '' then
                Evaluate(ExcelDataImport."Entry##", this.GetValueAtCell(TempExcelBuffer, RowNo, 2));

            if this.GetValueAtCell(TempExcelBuffer, RowNo, 3) <> '' then
                Evaluate(ExcelDataImport."Value 2", this.GetValueAtCell(TempExcelBuffer, RowNo, 3));

            if this.GetValueAtCell(TempExcelBuffer, RowNo, 4) <> '' then
                Evaluate(ExcelDataImport."Value 3", this.GetValueAtCell(TempExcelBuffer, RowNo, 4));

            if this.GetValueAtCell(TempExcelBuffer, RowNo, 5) <> '' then
                Evaluate(ExcelDataImport.UpdateField, this.GetValueAtCell(TempExcelBuffer, RowNo, 5));

            if this.GetValueAtCell(TempExcelBuffer, RowNo, 6) <> '' then
                Evaluate(ExcelDataImport."Value 4", this.GetValueAtCell(TempExcelBuffer, RowNo, 6));

            if ExcelDataImport.Insert(true) then
                i += 1;
        end;
        if I = 1 then
            Message('%1 record imported successfully', I)
        else
            if I > 0 then
                Message('%1 records imported successfully', I);
    end;

    local procedure GetValueAtCell(var TempExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; ColNo: Integer): Text
    begin
        TempExcelBuffer.Reset();
        if TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text");
        exit('');
    end;

}