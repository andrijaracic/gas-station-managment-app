using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BenzinskaPumpa.Shared
{
    
        public class Kategorija
        {
            public int KategorijaID { get; set; }
            public string Naziv { get; set; }
            public string Opis { get; set; }

            public override string ToString()
            {
                return Naziv;
            }

            
        }

        public class Usluga
        {
            public int UslugaID { get; set; }
            public string Naziv { get; set; }
            public decimal Cena { get; set; }
            public string Opis { get; set; }
            public int KategorijaID { get; set; }

            public string KategorijaNaziv { get; set; }
        }


}
