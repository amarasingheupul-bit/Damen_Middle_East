page 50115 "Update PPI Header Details"
{
    PageType = Card;
    Caption = 'Update PPI Header Related Data';
    ApplicationArea = All;
    UsageCategory = Administration;
    Permissions = tabledata "Purch. Inv. Header" = RIM,
                    tabledata "Excel Data Import General" = RIMD;


    actions
    {
        area(Processing)
        {
            action(UpdateData)
            {
                ApplicationArea = All;
                ToolTip = 'Tool Tip';
                Image = Process;

                trigger OnAction()
                begin

                    this.ExcelData.SetRange("Entry No.", 1, 1000);
                    if this.ExcelData.FindFirst() then
                        repeat

                            this.PINVHDR.Reset();
                            this.PINVHDR.SetFilter(this.PINVHDR."No.", '%1', this.ExcelData."Document No.");

                            if this.PINVHDR.FindFirst() then
                                repeat

                                    if this.ExcelData.UpdateField = 'CurFactor' then
                                        this.PINVHDR."Currency Factor" := this.ExcelData."Value 2";

                                    if this.ExcelData.UpdateField = 'SalesManager' then
                                        this.PINVHDR."Sales Manager" := this.ExcelData."Value 3";
                                    this.PINVHDR.Modify();

                                until this.PINVHDR.Next() = 0;

                        until this.ExcelData.Next() = 0;

                    Message('Process Finished');

                end;
            }
        }

    }
    var
        ExcelData: Record "Excel Data Import General";

        PINVHDR: Record "Purch. Inv. Header";
}