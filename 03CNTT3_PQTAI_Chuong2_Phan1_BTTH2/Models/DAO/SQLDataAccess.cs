using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Web2_Chuong1_Phan1_Demo8.Models.DAO
{
    public class SQLDataAccess
    {
        //Khai báo ham static private, chỉ xử dụng trong nội bộ hàm của class để lấy connectionstring.
        private static string LayConnectionString()
        {
            return System.Configuration.ConfigurationManager.ConnectionStrings["TAIPHANSQLServer"].ConnectionString; 
        }
        //SP có tham số para cho sp, và trả về kết quả truy vấn.
        public static DataTable ThucThiSPTraVeKetQua(string tensp,List<SqlParameter> paras)
        {
            DataTable ketqua=new DataTable();
            //Gọi hàm sể lấy thôi.
            string connectionstring = LayConnectionString();
            SqlConnection connection = new SqlConnection();
            connection.ConnectionString = connectionstring;
            connection.Open();
            SqlCommand command = new SqlCommand();
            command.Connection = connection;
            command.CommandText = tensp;
            command.CommandType = CommandType.StoredProcedure;
            if(paras!=null)
            {
                foreach(SqlParameter para in paras)
                {
                    command.Parameters.Add(para);
                }
            }
            SqlDataAdapter adapter=new SqlDataAdapter();
            adapter.SelectCommand=command;
            adapter.Fill(ketqua);
            connection.Close();
            return ketqua;
        }
        //SP không có tham số para cho sp, và trả về kết quả truy vấn.
        public static DataTable ThucThiSPTraVeKetQua(string tensp)
        {
            return ThucThiSPTraVeKetQua(tensp,null);
        }
        //SP có tham số para cho sp, không trả về kết quả truy vấn.
        public static void ThucThiSPKhongTraVeKetQua(string tensp, List<SqlParameter> paras)
        {
            string connectionstring = LayConnectionString();
            SqlConnection connection = new SqlConnection();
            connection.ConnectionString = connectionstring;
            connection.Open();
            SqlCommand command = new SqlCommand();
            command.Connection = connection;
            command.CommandText = tensp;
            command.CommandType = CommandType.StoredProcedure;
            if (paras != null)
            {
                foreach (SqlParameter para in paras)
                {
                    command.Parameters.Add(para);
                }
            }
            //chỉ cần kêu thực thi và dong kết nối là xong, vì đâu cần trả về giá trị.
            command.ExecuteNonQuery();
            connection.Close();
        }
        //SP không tham số para cho sp, không trả về kết quả truy vấn.
        public static void ThucThiSPKhongTraVeKetQua(string tensp)
        {
            //Chỉ đơn giản gọi hàm ở trên và tham số truyền vào là null thôi.
            ThucThiSPKhongTraVeKetQua(tensp, null);
        }
    }
}