module ApplicationHelper
  def navigation_items
    [
      { body: 'Listings', href: listings_path },
      { body: 'Reservations', href: reservations_path },
      { body: 'My Listings', href: host_listings_path },
    ]
  end

  def navigation_class(path)
    if current_page?(path)
      "bg-indigo-700 text-white rounded-md py-2 px-3 text-sm font-medium"
     else
      "text-white hover:bg-indigo-500 hover:bg-opacity-75 rounded-md py-2 px-3 text-sm font-medium"
    end
  end

  def navigation_aria(path)
    if current_page?(path)
      "page"
    else
      "false"
    end
  end
end
