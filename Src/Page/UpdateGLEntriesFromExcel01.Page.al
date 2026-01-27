page 50117 "Update GLEntries From Excel01"
{
    PageType = Card;
    Caption = 'Update GL Related Data From Excel General';
    ApplicationArea = All;
    UsageCategory = Administration;
    Permissions = tabledata "G/L Entry" = RMI,
                  tabledata "Excel Data Import General" = RIM;

    actions
    {
        area(Processing)
        {
            action(UpdateData)
            {
                ApplicationArea = All;
                ToolTip = 'Tool Tip';
                Image = Process;
                Caption = 'Update G/L Entries From Excel General';


                trigger OnAction()
                begin

                    this.ExcelData.SetRange("Entry No.", 1, 1000);
                    if this.ExcelData.FindFirst() then
                        repeat
                            this.EntryNoInt := this.ExcelData."Entry##";

                            this.GL.Reset();
                            this.GL.SetFilter(this.GL."Document No.", '%1', this.ExcelData."Document No.");

                            if this.GL.FindFirst() then
                                repeat


                                    if this.EntryNoInt <> 0 then
                                        if this.GL."Entry No." = this.EntryNoInt then begin

                                            if this.ExcelData.UpdateField = 'G/LAccount No.' then
                                                this.GL."G/L Account No." := this.ExcelData."Value 3";


                                            if this.ExcelData.UpdateField = 'Amount' then begin
                                                this.GL.Amount := this.ExcelData."Value 2";
                                                this.GL."Debit Amount" := 0;
                                                this.GL."Credit Amount" := 0;

                                                if this.ExcelData."Value 2" > 0 then
                                                    this.GL."Debit Amount" := this.ExcelData."Value 2"
                                                else
                                                    this.GL."Credit Amount" := this.ExcelData."Value 2";


                                            end;

                                            this.GL.Modify(true);


                                        end;





                                until this.GL.Next() = 0;
                        until this.ExcelData.Next() = 0;

                    Message('Process Finished');

                end;
            }
        }

    }
    var
        ExcelData: Record "Excel Data Import General";
        GL: Record "G/L Entry";
        EntryNoInt: Integer;


}