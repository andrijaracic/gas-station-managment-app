using BenzinskaPumpa.PristupPodacima;
using BenzinskaPumpa.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BenzinskaPumpa.PoslovnaLogika
{
    public class KategorijaManager
    {
        public List<Kategorija> GetAll()
        {
            var repo = new KategorijaRepo();
            return repo.GetAll();
        }
    }

}
