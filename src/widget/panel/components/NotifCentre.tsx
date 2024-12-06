import { NotifWidget, removeNotif } from "../../notifs/NotifWidget";
import AstalNotifd from "gi://AstalNotifd";
import { Gtk } from "astal/gtk3";
import { Astal } from "astal/gtk3";

const notifd = AstalNotifd.get_default();

export default function NotifCentre() {
  const notifMap: Map<number, Gtk.Widget> = new Map();

  notifd.get_notifications().map((n) => {
    notifMap.set(n.id, NotifWidget(n));
  });

  const NotifList = (
    <box spacing={8} vertical={true} className={"notifications"}>
      {[...notifMap.values()].reverse()}
    </box>
  );

  notifd.connect("notified", (_, id) => {
    const notif = notifd.get_notification(id);

    if (notif) {
      const lst = NotifList as Astal.Box;

      notifMap.get(id)?.destroy();
      notifMap.set(id, NotifWidget(notif));

      lst.set_children([...notifMap.values()].reverse());
    }
  });

  notifd.connect("resolved", (_, id) => {
    removeNotif(id, notifMap);
  });

  const NotifScroll = (
    <scrollable
      name={"notif-scroll"}
      heightRequest={400}
      hscroll={Gtk.PolicyType.NEVER}
      child={NotifList}
    ></scrollable>
  );

  return (
    <box className={"notif-centre"} vertical={true}>
      <centerbox
        className={"nc-header"}
        startWidget={
          <label
            heightRequest={24}
            label={"Notifications"}
            halign={Gtk.Align.START}
          />
        }
        endWidget={
          <button
            className={"clear-button"}
            heightRequest={24}
            widthRequest={24}
            halign={Gtk.Align.END}
            onClicked={() => {
              const notifs = notifd.get_notifications();

              for (const n of notifs) {
                notifd.get_notification(n.id).dismiss();
              }
            }}
          >
            <icon icon={"clear-all-symbolic"} css={"font-size: 14px;"} />
          </button>
        }
      />
      {NotifScroll}
    </box>
  );
}
