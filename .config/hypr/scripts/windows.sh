# hyprctl clients | awk '/title: ./ { gsub("\t*title: *", ""); print}' | tofi | xargs -I{} hyprctl dispatch focuswindow "title:{}" 
# hyprctl clients | awk '/class: ./ { gsub("\t*class: *", ""); print}' | tofi | xargs -I{} hyprctl dispatch focuswindow "class:{}" 


hypr-switch-en > /dev/null
hyprctl clients | awk '
/class: / {
    gsub(/^[[:space:]]*class: /, "")
    class = $0
}
/title: / {
    gsub(/^[[:space:]]*title: /, "")
    title = $0
    print class " - " title " - " address
    class = ""; title = ""
}
/address: / {
    gsub(/^[[:space:]]*address: /, "")
    address = $0
}' | tofi | awk -F' ' '{print $1}' | xargs -I{} hyprctl dispatch focuswindow "class:{}"
