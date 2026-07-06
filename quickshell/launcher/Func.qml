import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: funcs

    required property var root

    property var recentApps: []

    property FileView recentFile: FileView {
        path: Quickshell.env("HOME") + "/.cache/quickshell-launcher-recent.json"
        watchChanges: false

        onLoaded: {
            try {
                funcs.recentApps = JSON.parse(text())
            } catch (e) {
                funcs.recentApps = []
            }
        }
        onLoadFailed: funcs.recentApps = []
    }

    function fuzzyScore(text, query) {
        text = text.toLowerCase()
        query = query.toLowerCase()

        let score = 0
        let queryIndex = 0
        let lastMatchIndex = -1
        let consecutiveBonus = 0

        for (let i = 0; i < text.length && queryIndex < query.length; i++) {
            if (text[i] === query[queryIndex]) {
                if (lastMatchIndex === i - 1) {
                    consecutiveBonus += 5
                    score += consecutiveBonus
                } else {
                    consecutiveBonus = 0
                    score += 1
                }
                if (i === 0) score += 10
                lastMatchIndex = i
                queryIndex++
            }
        }

        if (queryIndex < query.length) return -1
        return score
    }

    function computeFilteredApps(query, allApps) {
        query = query.toLowerCase().trim()

        if (query.length === 0) {
            const recentSet = new Set(recentApps)
            const recent = recentApps
                .map(id => allApps.find(a => a.id === id))
                .filter(a => a !== undefined)
            const rest = allApps
                .filter(a => !recentSet.has(a.id))
                .sort((a, b) => a.name.localeCompare(b.name))
            return [...recent, ...rest]
        }

        const scored = []
        for (const app of allApps) {
            const score = fuzzyScore(app.name, query)
            if (score < 0) continue
            const recencyIndex = recentApps.indexOf(app.id)
            const recencyBonus = recencyIndex === -1 ? 0 : (20 - recencyIndex)
            scored.push({ app: app, score: score + recencyBonus })
        }
        scored.sort((a, b) => b.score - a.score)
        return scored.map(s => s.app)
    }

    function recordLaunch(app) {
        const id = app.id
        recentApps = [id, ...recentApps.filter(x => x !== id)]
        if (recentApps.length > 20) recentApps = recentApps.slice(0, 20)
        recentFile.setText(JSON.stringify(recentApps))
    }

    function launchCurrent(app) {
        if (!app) return
        recordLaunch(app)
        app.execute()
        root.isOpen = false
    }
}
