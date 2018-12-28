---
title: 'C# 导出 Excel'
categories:
  - 代码片段
  - 'c#'
tags:
  - dev
  - 'c#'
  - 代码片段
  - excel
abbrlink: aa2690c9
date: 2013-10-31 17:19:13
updated: 2018-07-28 10:24:13
---

<!--more-->

```csharp
/// <summary>
/// 导出Excel
/// </summary>
public void ExportExcel()
{
    #region 添加引用
    Microsoft.Office.Interop.Excel.Application app = new Microsoft.Office.Interop.Excel.Application();//需要添加 Microsoft.Office.Interop.Excel引用
    if (app == null) return;//app == null ，则代表服务器上“服务器上缺少Excel组件，需要安装Office软件”
    #endregion

    #region 设置app属性
    app.Visible = false;
    app.UserControl = true;
    Microsoft.Office.Interop.Excel.Workbooks workbooks = app.Workbooks;
    Microsoft.Office.Interop.Excel._Workbook workbook = workbooks.Add(Server.MapPath("~/Template/Template.xls")); //加载模板
    Microsoft.Office.Interop.Excel.Sheets sheets = workbook.Sheets;
    Microsoft.Office.Interop.Excel._Worksheet worksheet = null;
    Microsoft.Office.Interop.Excel.Range range = null;
    
    worksheet = (Microsoft.Office.Interop.Excel._Worksheet)sheets.get_Item(1);//获取第一个Sheet页
    if (worksheet == null)
        worksheet = (Microsoft.Office.Interop.Excel._Worksheet)workbook.Worksheets.Add(System.Type.Missing, System.Type.Missing, System.Type.Missing, System.Type.Missing);
    #endregion

    #region 根据获得的数据，进行数据的插入（到Excel模板中）
    var _row = 15;//从第15行开始导入列表
    
    //合并A14到K14
    range = worksheet.get_Range("A" + (_row - 1), "K" + (_row - 1));
    range.Merge(range.MergeCells);

    //取得数据集，并导入Excel
    DataTable table = new DataTable();
    for (int i = _row; i < table.Rows.Count + _row; i++)
    {
        worksheet.Cells[_row, 1] = "第_row行 第一列";
        worksheet.Cells[_row, 2] = "第_row行 第二列";
    }

    //插入行
    range = (Microsoft.Office.Interop.Excel.Range)worksheet.Rows[_row, Missing.Value];
    range.Insert(Microsoft.Office.Interop.Excel.XlInsertShiftDirection.xlShiftDown, Missing.Value);
    #endregion

    #region 对已导出好的Excel报表进行保存到服务器，以便进行下载
    if (!Directory.Exists(Server.MapPath("~/Excel/"))) Directory.CreateDirectory(Server.MapPath("~/Excel/"));
    string savaPath = "~/Excel/" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".xls";
    workbook.SaveAs(Server.MapPath(savaPath), Missing.Value, Missing.Value, Missing.Value, Missing.Value, Missing.Value, Microsoft.Office.Interop.Excel.XlSaveAsAccessMode.xlNoChange, Missing.Value, Missing.Value, Missing.Value, Missing.Value, Missing.Value);//Missing 在System.Reflection命名空间下。
    #endregion

    #region 释放资源
    // 关闭电子表格，释放资源
    workbook.Close(null, null, null);
    app.Workbooks.Close();
    workbook = null;

    // 退出 Excel，释放资源
    app.Quit();
    app = null;
    GC.Collect();
    #endregion

    #region 下载Excel
    Response.ContentType = "application/x-zip-compressed";
    Response.AddHeader("Content-Disposition", "attachment;filename=" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".xls");
    Response.TransmitFile(savaPath);
    Response.Flush();
    Response.Close();
    #endregion
}

/// <summary>
/// 用于excel表格中列号字母转成列索引，从1对应A开始
/// </summary>
/// <param name="column">列号</param>
/// <returns>列索引</returns>
private int ColumnToIndex(string column)
{
    if (!Regex.IsMatch(column.ToUpper(), @"[A-Z]+"))
    {
        throw new Exception("Invalid parameter");
    }
    int index = 0;
    char[] chars = column.ToUpper().ToCharArray();
    for (int i = 0; i < chars.Length; i++)
    {
        index += ((int)chars[i] - (int)'A' + 1) * (int)Math.Pow(26, chars.Length - i - 1);
    }
    return index;
}

/// <summary>
/// 用于将excel表格中列索引转成列号字母，从A对应1开始
/// </summary>
/// <param name="index">列索引</param>
/// <returns>列号</returns>
private string IndexToColumn(int index)
{
    if (index <= 0)
    {
        throw new Exception("Invalid parameter");
    }
    index--;
    string column = string.Empty;
    do
    {
        if (column.Length > 0)
        {
            index--;
        }
        column = ((char)(index % 26 + (int)'A')).ToString() + column;
        index = (int)((index - index % 26) / 26);
    } while (index > 0);
    return column;
}
```

> http://www.cnblogs.com/herbert/archive/2010/06/30/1768271.html