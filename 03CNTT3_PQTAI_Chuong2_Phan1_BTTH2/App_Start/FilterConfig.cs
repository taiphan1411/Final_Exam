using System.Web;
using System.Web.Mvc;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
        }
    }
}
