using ILike.Repository;
using Newtonsoft.Json;
using System.Net.Http;
using System.Net;
using System.Web.Mvc;

namespace ILike.Controllers
{
    public class HomeController : Controller
    {
		RepositoryDB repositoryDB = new RepositoryDB();

		public ActionResult _Layout()
		{
			return View();
		}
		public ActionResult MainPage()
		{
			return View();
		}

		[HttpPost]
		public ActionResult mainPage(string title, string urlImage, string Content)
		{

			if (repositoryDB.AddArticle(title, urlImage, Content) == true)
			{
				ViewBag.OperationStatus = "Ok";
				return View("MainPage");
			}
			else
			{
				ViewBag.OperationStatus = "Error";
				return View("MainPage");
			}
		}
	}
}