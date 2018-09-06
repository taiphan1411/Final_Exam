using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace _03CNTT3_PQTAI_Chuong2_Phan1_BTTH2.Models.DTO
{
    public class DauSach_DTO
    {
        protected string madausach;
        protected string tensach;
        protected string matacgia;
        protected string manhaxuatban;
        protected int soluong;
        protected string bia;
        protected string tomtat;
        protected string filesach;
        protected DateTime ngaydang;
        protected string machude;
        protected int luotxem;
        public DauSach_DTO()
        {
            this.madausach = "";
            this.tensach = "";
            this.matacgia = "";
            this.manhaxuatban = "";
            this.soluong = -1;
            this.bia = "";
            this.tomtat = "";
            this.filesach = "";
            this.ngaydang = new DateTime(1,1,1);
            this.machude = "";
            this.luotxem = -1;
        }
        public string Madausach
        {
            get
            {
                return madausach;
            }

            set
            {
                madausach = value;
            }
        }

        public string Tensach
        {
            get
            {
                return tensach;
            }

            set
            {
                tensach = value;
            }
        }

        public string Matacgia
        {
            get
            {
                return matacgia;
            }

            set
            {
                matacgia = value;
            }
        }

        public string Manhaxuatban
        {
            get
            {
                return manhaxuatban;
            }

            set
            {
                manhaxuatban = value;
            }
        }

        public int Soluong
        {
            get
            {
                return soluong;
            }

            set
            {
                soluong = value;
            }
        }

        public string Bia
        {
            get
            {
                return bia;
            }

            set
            {
                bia = value;
            }
        }

        public string Tomtat
        {
            get
            {
                return tomtat;
            }

            set
            {
                tomtat = value;
            }
        }

        public string Filesach
        {
            get
            {
                return filesach;
            }

            set
            {
                filesach = value;
            }
        }

        public DateTime Ngaydang
        {
            get
            {
                return ngaydang;
            }

            set
            {
                ngaydang = value;
            }
        }

        public string Machude
        {
            get
            {
                return machude;
            }

            set
            {
                machude = value;
            }
        }

        public int Luotxem
        {
            get
            {
                return luotxem;
            }

            set
            {
                luotxem = value;
            }
        }
    }
}