using System.Web.Mvc;

namespace ILike.Controllers
{
    public class HomeController : Controller
    {
		public ActionResult _Layout()
		{
			return View();
		}
		public ActionResult MainPage()
		{
			return View();
		}
	}
}