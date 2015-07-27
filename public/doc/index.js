/* global React:true */

function configure() {
  var $__0=     window,hljs=$__0.hljs,marked=$__0.marked;

  marked.setOptions({
    highlight: function (code) {
      return hljs.highlightAuto(code).value;
    }
  });
}

function generateSorter(key) {
  return function(a, b) {
    if (a[key] > b[key]) {
      return 1;
    }
    else if (a[key] < b[key]) {
      return -1;
    }
    else {
      return 0;
    }
  };
}

function prepareDatabase(database) {
  var sortById = generateSorter('id');

  database.forEach(function(group)  {
    group.entries.sort(sortById);
  });

  return database;
}

function getActiveEntryPath() {
  var path = window.location.hash.replace(/^#/, '').split('/');

  if (path.length > 1) {
    return {
      group: path[0],
      entry: path.slice(1).join('/')
    };
  }
  else {
    return {
      group: 'YARD-API',
      entry: 'README'
    };
  }
}

(function(marked) {
  var delegate;

  var SidebarLink = React.createClass({displayName: "SidebarLink",
    render:function() {
      var activeContext = getActiveEntryPath();
      var $__0=     this.props,group=$__0.group,entry=$__0.entry;
      var isActive = (
        group === activeContext.group &&
        entry === activeContext.entry
      );

      return (
        React.createElement("a", {
          className: isActive ? 'active' : null, 
          href: '#' + group + '/' + entry
        }, 
          entry
        )
      );
    },

    navigate:function() {

    }
  });

  var Sidebar = React.createClass({displayName: "Sidebar",
    getDefaultProps:function() {
      return {
        groups: []
      };
    },

    render:function() {
      return (
        React.createElement("div", {className: "yard-api--sidebar"}, 
          this.props.groups.map(this.renderGroup)
        )
      );
    },

    renderGroup:function(group) {
      return (
        React.createElement("div", {key: group.id}, 
          React.createElement("h2", null, group.id), 

          React.createElement("ul", {className: "yard-api--sidebar_listing"}, 
            group.entries.map(this.renderEntry.bind(null, group.id))
          )
        )
      );
    },

    renderEntry:function(groupId, entry) {
      return (
        React.createElement("li", {key: entry.id}, 
          React.createElement(SidebarLink, {group: groupId, entry: entry.id})
        )
      );
    }
  });

  var Content = React.createClass({displayName: "Content",
    render:function() {
      return (
        React.createElement("div", {
          className: "yard-api--content", 
          dangerouslySetInnerHTML: {__html: marked(this.props.html)}}
        )
      );
    }
  });

  var Root = React.createClass({displayName: "Root",
    componentDidMount:function() {
      window.title = this.props.config.title;  
      window.addEventListener('hashchange', function()  {
        this.forceUpdate();
      }.bind(this));
    },

    render:function() {
      var activeEntryPath = getActiveEntryPath();
      var activeEntry;
      var activeGroup = this.props.database.filter(function(group)  {
        return group.id === activeEntryPath.group;
      })[0];

      if (activeGroup) {
        activeEntry = activeGroup.entries.filter(function(entry)  {
          return entry.id === activeEntryPath.entry;
        })[0];
      }

      return (
        React.createElement("div", null, 
          React.createElement(Sidebar, {
            groups: this.props.database}
          ), 

          activeEntry && React.createElement(Content, {html: activeEntry.content})
        )
      );
    }
  });

  configure();

  delegate = React.render(
    React.createElement(Root, {
      config: window.CONFIG, 
      database: prepareDatabase(window.DATABASE)}
    ),
    document.body
  );
}(window.marked));
