from kittens.tui.handler import result_handler


def main(args):
    pass


def toggle_term(boss):
    tab = boss.active_tab

    all_another_wins = tab.all_window_ids_except_active_window
    have_only_one = len(all_another_wins) == 0

    if have_only_one:
        # Store the current window before creating new one
        current_window = boss.active_window
        # Create new window with hsplit (will be created below in most cases)
        boss.launch('--cwd=current', '--location=hsplit')
        # Focus back on the original window, then navigate down
        boss.set_active_window(current_window)
        tab.neighboring_window("bottom")
    else:
        if tab.current_layout.name == 'stack':
            tab.last_used_layout()
            tab.neighboring_window("bottom")
        else:
            tab.neighboring_window("bottom")
            tab.goto_layout('stack')


@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    window = boss.window_id_map.get(target_window_id)

    if window is None:
        return

    toggle_term(boss)
