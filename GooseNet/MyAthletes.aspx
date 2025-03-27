<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="MyAthletes.aspx.cs" Inherits="GooseNet.MyAthletes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Athletes - GooseNet</title>
    <style>
        .workoutBtns {
    padding: 12px 24px;
    background: linear-gradient(135deg, #ff6b6b, #ff5252);
    color: white;
    font-size: 0.8em;
    font-weight: bold;
    text-transform: uppercase;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 4px 10px rgba(255, 107, 107, 0.3);
}

 .workoutBtns:hover {
    background: linear-gradient(135deg, #ff5252, #ff3b3b);
    box-shadow: 0 6px 15px rgba(255, 82, 82, 0.5);
    transform: translateY(-2px);
}

 .workoutBtns:active {
    transform: translateY(1px);
    box-shadow: 0 2px 5px rgba(255, 82, 82, 0.4);
}

 .athleteName{
     font-size:2vw;
 }

 fieldset{
     border:3px solid;
  
 }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <center>   <%ShowConnectedAthletes(GetConnectedAthletes()); %>
</center>

</asp:Content>
