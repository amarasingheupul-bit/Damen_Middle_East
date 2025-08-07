pageextension 50101 "PostCodesS365" extends "Post Codes"
{
    layout
    {
        addfirst(Control1)
        {
            field("Type S365"; Rec."Type S365")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the post code Type.';
            }
        }
    }
}
