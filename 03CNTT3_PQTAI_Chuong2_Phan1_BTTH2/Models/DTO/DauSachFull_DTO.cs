using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO
{
    public class DauSachFull_DTO:DauSach_DTO
    {
        protected string tentacgia;
        protected string tennhaxuatban;
        protected string tenchude;
        public DauSachFull_DTO() : base()
        {
            this.tentacgia = "";
            this.tennhaxuatban = "";
            this.tenchude = "";
        }
        public string Tentacgia
        {
            get
            {
                return tentacgia;
            }

            set
            {
                tentacgia = value;
            }
        }

        public string Tennhaxuatban
        {
            get
            {
                return tennhaxuatban;
            }

            set
            {
                tennhaxuatban = value;
            }
        }

        public string Tenchude
        {
            get
            {
                return tenchude;
            }

            set
            {
                tenchude = value;
            }
        }


    }
}