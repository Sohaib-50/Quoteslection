document.addEventListener("DOMContentLoaded", function()
{
    let non_fav_heart_icon = "<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='currentColor' class='bi bi-heart' viewBox='0 0 16 16'><path d='m8 2.748-.717-.737C5.6.281 2.514.878 1.4 3.053c-.523 1.023-.641 2.5.314 4.385.92 1.815 2.834 3.989 6.286 6.357 3.452-2.368 5.365-4.542 6.286-6.357.955-1.886.838-3.362.314-4.385C13.486.878 10.4.28 8.717 2.01L8 2.748zM8 15C-7.333 4.868 3.279-3.04 7.824 1.143c.06.055.119.112.176.171a3.12 3.12 0 0 1 .176-.17C12.72-3.042 23.333 4.867 8 15z'/></svg>";
    let fav_heart_icon = "<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='currentColor' class='bi bi-heart-fill' viewBox='0 0 16 16'><path fill-rule='evenodd' d='M8 1.314C12.438-3.248 23.534 4.735 8 15-7.534 4.736 3.562-3.248 8 1.314z'/></svg>";

    let fav_btns = document.querySelectorAll(".fav_btn");  // get all buttons

    for (let i = 0; i < fav_btns.length; i++)  // for each button
    {
        let current_btn = fav_btns[i];
        let quote_id = current_btn.id.slice("quoteid-".length);
        current_btn.addEventListener("click", function () {
            let btn_content = current_btn.innerHTML
            let is_favourite = btn_content.includes("bi-heart-fill") ? true : false;
            $.post("/favouriteify_quote", { quote_id: quote_id, is_favourite: is_favourite }, function (data, status) {
                if (status == "success")
                {
                    let new_fav_count = data["fav_count"];
                    if (is_favourite) // if currently button was favourite-d, un favourite it
                    {
                        current_btn.innerHTML = non_fav_heart_icon;
                    }
                    else   // favourite the button
                    {
                        current_btn.innerHTML = fav_heart_icon;
                    }
                    current_btn.nextElementSibling.innerHTML = new_fav_count;  // update favorite count
                }
            });
        });
    }
});

