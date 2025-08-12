<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AddToFlock.aspx.cs" Inherits="GooseNet.AddToFlock" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mx-auto px-4 py-8 max-w-xl">
        <h1 class="text-4xl font-extrabold text-white mb-8 text-center">Choose Flock To Add Athlete To:</h1>

        <div class="grid grid-cols-1 gap-6">
            <%ShowConnectionButtons(); %>
        </div>
    </div>

</asp:Content>
