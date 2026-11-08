# Ask before quitting kitty. Mapped to cmd+q in macos.conf.
# confirm_os_window_close stays 0 in kitty.conf, so cmd+w / shift+cmd+w
# still close tabs and OS windows without asking; only quitting confirms.
from kittens.tui.handler import result_handler


def main(args):
    pass


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    def on_answer(confirmed, *a):
        if confirmed:
            boss.quit()

    boss.confirm(
        'Quit kitty and close all windows?',
        on_answer,
        window=boss.window_id_map.get(target_window_id) or boss.active_window,
        title='Quit kitty',
    )
