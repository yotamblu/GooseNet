<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="FlocksMenu.aspx.cs" Inherits="GooseNet.FlocksMenu" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    
    <center style="margin-top:20%">
    
    <%ShowMyFlocksBtn(); %>
      <button style="margin-left:10vw;transform:scale(2)"><a href="CreateFlock.aspx">Create Flock</a></button>

</center>

</asp:Content>
