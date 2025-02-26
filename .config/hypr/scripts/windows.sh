# hyprctl clients | awk '/title: ./ { gsub("\t*title: *", ""); print}' | tofi | xargs -I{} hyprctl dispatch focuswindow "title:{}" 
hyprctl clients | awk '/class: ./ { gsub("\t*class: *", ""); print}' | tofi | xargs -I{} hyprctl dispatch focuswindow "class:{}" 
