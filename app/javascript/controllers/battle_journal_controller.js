import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["pagesContainer", "page", "pageDots"]

  connect() {
    this.currentPage = 0
    this.totalPages = this.pageTargets.length

    // Update dots on scroll
    this.pagesContainerTarget.addEventListener('scroll', this.handleScroll.bind(this))
  }

  disconnect() {
    this.pagesContainerTarget.removeEventListener('scroll', this.handleScroll.bind(this))
  }

  handleScroll() {
    const container = this.pagesContainerTarget
    const scrollLeft = container.scrollLeft
    const pageWidth = container.offsetWidth

    // Calculate which page we're on
    const newPage = Math.round(scrollLeft / pageWidth)

    if (newPage !== this.currentPage) {
      this.currentPage = newPage
      this.updateDots()
    }
  }

  updateDots() {
    const dots = this.pageDotsTarget.querySelectorAll('.dot')

    dots.forEach((dot, index) => {
      if (index === this.currentPage) {
        dot.classList.add('active')
      } else {
        dot.classList.remove('active')
      }
    })
  }

  goToPage(event) {
    const pageIndex = parseInt(event.currentTarget.dataset.page)
    this.scrollToPage(pageIndex)
  }

  scrollToPage(index) {
    const container = this.pagesContainerTarget
    const pageWidth = container.offsetWidth

    container.scrollTo({
      left: pageWidth * index,
      behavior: 'smooth'
    })

    this.currentPage = index
    this.updateDots()
  }

  prevPage() {
    if (this.currentPage > 0) {
      this.scrollToPage(this.currentPage - 1)
    }
  }

  nextPage() {
    if (this.currentPage < this.totalPages - 1) {
      this.scrollToPage(this.currentPage + 1)
    }
  }
}
