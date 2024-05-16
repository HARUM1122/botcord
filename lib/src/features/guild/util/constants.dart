const List<(String, int)> generalPerms = [
  ('Administrator', 8),
  ('View Audit Log', 128),
  ('Manage Server', 32),
  ('Manage Roles', 268435456),
  ('Manage Channels', 16),
  ('Kick Members', 2),
  ('Ban Members', 4),
  ('Create Instant Invite', 1),
  ('Change Nickname', 67108864),
  ('Manage Nicknames', 134217728),
  ('Create Expressions', 8796093022208),
  ('Manage Webhooks Read', 536870912),
  ('Messages/View Channels', 1024),
  ('Manage Events', 8589934592),
  ('Create Events', 17592186044416),
  ('Moderate Members', 1099511627776),
  ('View Server Insights', 524288),
  ('Monetization Insights', 2199023255552),
], textPerms = [
  ('Send Messages', 2048),
  ('Create Public Threads', 34359738368),
  ('Create Private Threads', 68719476736),
  ('Send Messages in Threads', 274877906944),
  ('Send TTS Messages', 4096),
  ('Manage Messages', 8192),
  ('Manage Threads', 17179869184),
  ('Embed Links', 16384),
  ('Attach Files', 32768),
  ('Read Message History', 65536),
  ('Mention Everyone', 131072),
  ('Use External Stickers', 137438953472),
  ('Add Reactions', 64),
  ('Use Slash Commands', 2147483648),
  ('Use Embedded Activities', 549755813888),
], voicePerms = [
  ('Mute Members', 4194304),
  ('Deafen Members', 8388608),
  ('Move Members', 16777216),
  ('Create Polls', 562949953421312),
];