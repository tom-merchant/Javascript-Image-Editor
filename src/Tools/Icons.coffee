###
Icons.coffee
Holds all of the icons and cursors for the tools

Tom Merchant 2018
###

#include <jdefs.h>

Icons:
  Pencil:
    icon: "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+CjwhLS0gQ3JlYXRlZCB3aXRoIElua3NjYXBlIChodHRwOi8vd3d3Lmlua3NjYXBlLm9yZy8pIC0tPgoKPHN2ZwogICB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iCiAgIHhtbG5zOmNjPSJodHRwOi8vY3JlYXRpdmVjb21tb25zLm9yZy9ucyMiCiAgIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyIKICAgeG1sbnM6c3ZnPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIKICAgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIgogICB4bWxuczpzb2RpcG9kaT0iaHR0cDovL3NvZGlwb2RpLnNvdXJjZWZvcmdlLm5ldC9EVEQvc29kaXBvZGktMC5kdGQiCiAgIHhtbG5zOmlua3NjYXBlPSJodHRwOi8vd3d3Lmlua3NjYXBlLm9yZy9uYW1lc3BhY2VzL2lua3NjYXBlIgogICB3aWR0aD0iMC41aW4iCiAgIGhlaWdodD0iMC41aW4iCiAgIHZpZXdCb3g9IjAgMCA0NS4wMDAwMDEgNDUuMDAwMDAxIgogICBpZD0ic3ZnMiIKICAgdmVyc2lvbj0iMS4xIgogICBpbmtzY2FwZTp2ZXJzaW9uPSIwLjkxIHIxMzcyNSIKICAgc29kaXBvZGk6ZG9jbmFtZT0icGVuY2lsLnN2ZyI+CiAgPGRlZnMKICAgICBpZD0iZGVmczQiIC8+CiAgPHNvZGlwb2RpOm5hbWVkdmlldwogICAgIGlkPSJiYXNlIgogICAgIHBhZ2Vjb2xvcj0iI2ZmZmZmZiIKICAgICBib3JkZXJjb2xvcj0iIzY2NjY2NiIKICAgICBib3JkZXJvcGFjaXR5PSIxLjAiCiAgICAgaW5rc2NhcGU6cGFnZW9wYWNpdHk9IjAuMCIKICAgICBpbmtzY2FwZTpwYWdlc2hhZG93PSIyIgogICAgIGlua3NjYXBlOnpvb209IjQiCiAgICAgaW5rc2NhcGU6Y3g9IjkuNTQ2OTA1OSIKICAgICBpbmtzY2FwZTpjeT0iMzUuNTAzNDc4IgogICAgIGlua3NjYXBlOmRvY3VtZW50LXVuaXRzPSJweCIKICAgICBpbmtzY2FwZTpjdXJyZW50LWxheWVyPSJsYXllcjEiCiAgICAgc2hvd2dyaWQ9ImZhbHNlIgogICAgIHVuaXRzPSJpbiIKICAgICBpbmtzY2FwZTp3aW5kb3ctd2lkdGg9IjEzNjYiCiAgICAgaW5rc2NhcGU6d2luZG93LWhlaWdodD0iNzA1IgogICAgIGlua3NjYXBlOndpbmRvdy14PSIwIgogICAgIGlua3NjYXBlOndpbmRvdy15PSIzMCIKICAgICBpbmtzY2FwZTp3aW5kb3ctbWF4aW1pemVkPSIxIiAvPgogIDxtZXRhZGF0YQogICAgIGlkPSJtZXRhZGF0YTciPgogICAgPHJkZjpSREY+CiAgICAgIDxjYzpXb3JrCiAgICAgICAgIHJkZjphYm91dD0iIj4KICAgICAgICA8ZGM6Zm9ybWF0PmltYWdlL3N2Zyt4bWw8L2RjOmZvcm1hdD4KICAgICAgICA8ZGM6dHlwZQogICAgICAgICAgIHJkZjpyZXNvdXJjZT0iaHR0cDovL3B1cmwub3JnL2RjL2RjbWl0eXBlL1N0aWxsSW1hZ2UiIC8+CiAgICAgICAgPGRjOnRpdGxlIC8+CiAgICAgIDwvY2M6V29yaz4KICAgIDwvcmRmOlJERj4KICA8L21ldGFkYXRhPgogIDxnCiAgICAgaW5rc2NhcGU6bGFiZWw9IkxheWVyIDEiCiAgICAgaW5rc2NhcGU6Z3JvdXBtb2RlPSJsYXllciIKICAgICBpZD0ibGF5ZXIxIgogICAgIHRyYW5zZm9ybT0idHJhbnNsYXRlKDAsLTEwMDcuMzYyMSkiPgogICAgPHBhdGgKICAgICAgIHNvZGlwb2RpOnR5cGU9InN0YXIiCiAgICAgICBzdHlsZT0iZmlsbDojMDAwMDAwIgogICAgICAgaWQ9InBhdGgzMzQ2IgogICAgICAgc29kaXBvZGk6c2lkZXM9IjMiCiAgICAgICBzb2RpcG9kaTpjeD0iOS43NzI5NzA4IgogICAgICAgc29kaXBvZGk6Y3k9IjEwNDQuMTM3MiIKICAgICAgIHNvZGlwb2RpOnIxPSI3LjMwMTU0MDkiCiAgICAgICBzb2RpcG9kaTpyMj0iMy45ODgyNDA1IgogICAgICAgc29kaXBvZGk6YXJnMT0iMi4yMzQ4NDI1IgogICAgICAgc29kaXBvZGk6YXJnMj0iMy4yODIwNCIKICAgICAgIGlua3NjYXBlOmZsYXRzaWRlZD0iZmFsc2UiCiAgICAgICBpbmtzY2FwZTpyb3VuZGVkPSIwIgogICAgICAgaW5rc2NhcGU6cmFuZG9taXplZD0iMCIKICAgICAgIGQ9Im0gNS4yNzI5NzExLDEwNDkuODg3MiAwLjU1MTAyOTksLTYuMzA4MyAxLjIxOTMyNDIsLTYuMjEzOCA1LjE4NzYzMTgsMy42MzEzIDQuNzcxNjYsNC4xNjI5IC01LjczODY2MSwyLjY3NyB6IgogICAgICAgaW5rc2NhcGU6dHJhbnNmb3JtLWNlbnRlci14PSItMS4zNjQ4MjMxIgogICAgICAgaW5rc2NhcGU6dHJhbnNmb3JtLWNlbnRlci15PSItMC41MTEwNTcxNyIgLz4KICAgIDxyZWN0CiAgICAgICBzdHlsZT0iZmlsbDojMDAwMDAwIgogICAgICAgaWQ9InJlY3QzMzQ4IgogICAgICAgd2lkdGg9IjIwLjI1IgogICAgICAgaGVpZ2h0PSIxMy4yNSIKICAgICAgIHg9Ii04MDMuOTMxNTIiCiAgICAgICB5PSI2NTAuODI2NjYiCiAgICAgICB0cmFuc2Zvcm09Im1hdHJpeCgwLjYyMjQ5NDA0LC0wLjc4MjYyNDU0LDAuNzgyNjI0NTQsMC42MjI0OTQwNCwwLDApIiAvPgogICAgPHJlY3QKICAgICAgIHN0eWxlPSJmaWxsOiMwMDAwMDAiCiAgICAgICBpZD0icmVjdDMzNTAiCiAgICAgICB3aWR0aD0iMTIuNTUxMTQ2IgogICAgICAgaGVpZ2h0PSI5LjcyMjcxODIiCiAgICAgICB4PSI2NTAuNDg5ODciCiAgICAgICB5PSI3NzEuNTc1MTMiCiAgICAgICB0cmFuc2Zvcm09Im1hdHJpeCgwLjc4Mjk4Njc3LDAuNjIyMDM4MzYsLTAuNjIyMDM4MzYsMC43ODI5ODY3NywwLDApIgogICAgICAgcnk9IjIuNDgzNzU3IiAvPgogICAgPHJlY3QKICAgICAgIHN0eWxlPSJmaWxsOiNmZmZmZmYiCiAgICAgICBpZD0icmVjdDMzMzgiCiAgICAgICB3aWR0aD0iMS4xMzE5MDc4IgogICAgICAgaGVpZ2h0PSIxOS40OTY1OTMiCiAgICAgICB4PSI2MzEuNzQxNjQiCiAgICAgICB5PSI3NjEuNjkzNjYiCiAgICAgICB0cmFuc2Zvcm09Im1hdHJpeCgwLjc1OTY0Mjc1LDAuNjUwMzQwNiwtMC41OTY1MjIzMSwwLjgwMjU5NjQ5LDAsMCkiIC8+CiAgPC9nPgo8L3N2Zz4K"
    cursor: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAORJREFUOI2tzzFuwkAQheGf3IPKnZVuuQA5gI+Qkj5FaOAKLrkCJ4hCl1C4TBERy0xtUdHRIBDsTBqINi7idZKRptvvvR344/S6PDawBu7dxECX4rYF2y5l3/Dxg6MJZmZmYAaWP5JHBdSv1F9YMF2j+TgCJ32SYk6hgl7xYcVhcMsgqrl8ogybTTB5RlqhS3H1C3XYvHtjJwvEpbgf8WTERAUNm32FT/okrc2zKbMmVkGzO7Kom5vYBNss2URhAF/hQ+wrfOvNwdjDPXqu0FPJaf/OPhtGfv0acFntgv4FhwG/mk/+I7Ece/kqigAAAABJRU5ErkJggg=="

global.tools.getIcon = (name) ->
  global.assert Icons.hasOwnProperty name
  return Icons["name"].icon

global.tools.getCursor = (name) ->
  global.assert Icons.hasOwnProperty name
  return Icons["name"].cursor

global.tools.tools = [global.tools.Pencil]
