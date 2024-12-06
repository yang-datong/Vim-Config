import gdb
import re


def remove_ansi_escape_sequences(text):
    # ANSI转义序列的正则表达式
    ansi_escape = re.compile(r'''
        \x1B  # ESC
        (?:   # 7-bit C1 Fe (除了CSI)
            [@-Z\\-_]
        |     # 或者
            \[  # CSI
            [0-?]*  # 参数字节
            [ -/]*  # 中间字节
            [@-~]   # 最终字节
        )
    ''', re.VERBOSE)
    return ansi_escape.sub('', text)

class HideCommand(gdb.Command):
    """Custom command to hide components in GEF context layout"""

    def __init__(self):
        super(HideCommand, self).__init__("hide", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        # Split arguments and handle no argument case
        args = arg.split()
        # if len(args) != 1:
            # print("Usage: hide <component>")
            # return
        # print(args)

        output = remove_ansi_escape_sequences(gdb.execute("gef config context.layout", to_string=True))
        match = re.search(r"\"(.*?)\"", output)
        # if match:
            # print(str(match.group(0)))

        component = args[0]
        components = ["-legend", "regs", "-stack", "code", "args", "source", "threads", "trace", "extra", "memory"]
        # print((components))
        if match:
            components = match.group(0).replace('\x01', '').replace('\x02', '').replace('\"', '').split()

        # print((components))
        if component not in components:
            print(f"Invalid component: {component}")
            return

        # Create the new layout configuration by excluding the specified component
        new_layout = ' '.join(f"-{c}" if c == component else c for c in components)

        # Set the new configuration in GEF
        gdb.execute(f"gef config context.layout \"{new_layout}\"")

HideCommand()

