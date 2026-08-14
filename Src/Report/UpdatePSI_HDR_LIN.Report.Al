#pragma warning disable AA0215
report 50114 "Update PSI HDR&Lines"
#pragma warning restore AA0215

{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Update SI Entries';
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Sales Header" = RIMD,
                  tabledata "Sales Line" = RIMD;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")

        {
            RequestFilterFields = "No.";
            trigger OnAfterGetRecord()
            begin

                if GetFilter("No.") <> '' then begin

                    if this.NewFielddec <> 0 then "Currency Factor" := this.NewFielddec;
                    if this.NewFielddec <> 0 then Amount := this.NewFielddec02;
                    Modify();
                end;
            end;

        }

        dataitem("Sales Line"; "Sales Line")

        {
            RequestFilterFields = "Document No.";
            trigger OnAfterGetRecord()
            begin

                if GetFilter("Document No.") <> '' then begin

                    if this.NewFieldDec03 <> 0 then "Outstanding Amount (LCY)" := this.NewFieldDec03;
                    if this.NewFielddec02 <> 0 then "Line Amount" := this.NewFielddec02;
                    if this.NewFielddec02 <> 0 then "Outstanding Amount" := this.NewFielddec02;
                    if this.NewFielddec02 <> 0 then Amount := this.NewFielddec02;
                    if this.NewFielddec02 <> 0 then "Amount Including VAT" := this.NewFielddec02;

                    Modify();
                end;
            end;

        }



    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Option)
                {
                    field(NewFielddec; NewFielddec)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                        ToolTip = 'New Value Rate';
                        Caption = 'New Value Rate';
                        DecimalPlaces = 4;
                    }


                    field(NewFielddec02; NewFielddec02)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                        ToolTip = 'New Value LCY';
                        Caption = 'New Value LCY';
                    }

                    field(NewFieldDec03; NewFieldDec03)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                        ToolTip = 'New Value ';
                        Caption = 'New Value ';
                    }

                }
            }
        }
    }


    var

        NewFielddec: Decimal;
        NewFielddec02: Decimal;

        NewFieldDec03: Decimal;
}


