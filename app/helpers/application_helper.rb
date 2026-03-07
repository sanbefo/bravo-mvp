module ApplicationHelper
  def flag_for(country_code)
    return if country_code.blank?

    # This assumes country_code is "MX" or "PT"
    # and files are "mx.png" or "pt.png"
    image_tag("#{country_code.downcase}.png",
              alt: country_code,
              class: "w-6 h-4 object-cover rounded-sm inline-block mb-0.5")
  end

  def status_badge(status)
    # Define styles for each status
    case status.to_s
    when 'pending'
      styles = "bg-amber-100 text-amber-700"
      dot_color = "bg-amber-500"
    when 'under_review'
      styles = "bg-blue-100 text-blue-700"
      dot_color = "bg-blue-500"
    when 'approved'
      styles = "bg-green-100 text-green-700"
      dot_color = "bg-green-500"
    when 'rejected'
      styles = "bg-red-100 text-red-700"
      dot_color = "bg-red-500"
    else
      styles = "bg-gray-100 text-gray-700"
      dot_color = "bg-gray-500"
    end

    # Build the HTML structure
    content_tag :span, class: "inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wider #{styles}" do
      concat content_tag(:span, "", class: "w-1.5 h-1.5 rounded-full #{dot_color}")
      concat status.to_s.humanize
    end
  end

  def country_name(country_code)
    return "" if country_code.blank?

    countries = {
      "MX" => "Mexico",
      "PT" => "Portugal"
    }

    # .upcase ensures it works even if you pass "mx" or "pt"
    countries[country_code.upcase] || country_code.upcase
  end
end
