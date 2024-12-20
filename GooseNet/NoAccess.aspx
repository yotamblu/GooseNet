<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="NoAccess.aspx.cs" Inherits="GooseNet.NoAccess" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

<style>
    h3{
        color:white;
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <center>
        <h3>Oops!, you have <br />No Access to this Page!</h3> <br />
        <button><a href="HomePage.aspx">Return To Home Page</a></button>
    </center>
</asp:Content>
