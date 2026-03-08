module CreditApplicationsHelper
  def format_account_number(number, country_code)
    return number if number.blank?

    case country_code.to_s.upcase
    when 'MX' # CLABE: 3-3-11-1
      "#{number[0..2]} #{number[3..5]} #{number[6..16]} #{number[17]}"
    when 'PT' # NIB: 4-4-11-2
      "#{number[0..3]} #{number[4..7]} #{number[8..18]} #{number[19..20]}"
    when 'ES' # IBAN: 4-4-4-4-4-4
      number.scan(/.{4}/).join(' ')
    else
      # Default: Chunk by 4 for anything unknown (like a generic Credit Card)
      number.scan(/.{1,4}/).join(' ')
    end
  end
end
