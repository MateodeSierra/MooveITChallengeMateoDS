
[![LinkedIn][linkedin-shield]][linkedin-url]



<br />
<p align="center">
  <h3 align="center">READ-ME MooveIT Challenge</h3>

  <p align="center">
    README for the MooveIT Ruby Challenge made by Mateo de Sierra
    <br />
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

This project was made by Mateo de Sierra, as part of the employee selection program for MooveIT.

### Built With

* [Ruby](https://www.ruby-lang.org/)
* [Rspec](https://rspec.info/)
* [VisualCode](https://code.visualstudio.com/)



<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple example steps. (Guide made for Windows10)


### Server and Client Installation

1. Download the repo and unzip

   https://github.com/MateodeSierra/MooveITChallengeMateoDS)

2. Go into the repo folder, into the lib folder, and double click the "main.rb" file
3. If you reach this state the server is already running on the port displayed on screen

   ![Server running!](https://i.imgur.com/qSOW8B8.png)
4. To open a client, first you need to turn on telnet on your PC. To acomplish this, right click the Start button and select "Programs and Features", then click "Turn Windows features on or off" from the left hand menu.

5. The following windows appears, scroll down and select Telnet Client, then press OK

   ![Telnet Selected](https://kencenerelli.files.wordpress.com/2017/07/telnet03_thumb.png?w=415&h=368)

6. Wait for the instalation to finish, after this, to test if telnet is correctly installed, go into cmd and type telnet. You can press help to see all available commands.

7. To open a client via Telnet, go into cmd and type "telnet localhost" followed by a space and the port number displayed on the server window.

8. If you reach this window, the client is running and you are connected to the server. You can start entering commands.

   ![Client connected!](https://i.imgur.com/QoZkzi6.png)

### Test environment Installation

1. Download Visual Code or any other ruby capable source code editor  [VisualCode](https://code.visualstudio.com/)

2. Open Visual Code and install the Ruby extension
   ![Extension image](https://i.imgur.com/YQ70jGK.png)

3. Go into cmd and type "gem install rspec", this gem is used for testing the code

4. Once Rspec is intalled, go back into Visual Code and open your project folder, then right click the "memcached_spec.rb" file, and select "Open in Integrated Terminal".
   ![Open Terminal](https://i.imgur.com/52OM44p.png)

5. The opened terminal should look like this:
   ![Terminal](https://i.imgur.com/dE8AuTH.png)

6. To run the tests type "rspec ..\spec\memcached_spec.rb" into the terminal then press ENTER. If all tests run correctly all dots should be green and no error message should pop up. To check how tests work, double click the "memcached_spec.rb" file on your workspace folder.





<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_



<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/othneildrew/Best-README-Template/issues) for a list of proposed features (and known issues).



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.



<!-- CONTACT -->
## Contact

Your Name - [@your_twitter](https://twitter.com/your_username) - email@example.com

Project Link: [https://github.com/your_username/repo_name](https://github.com/your_username/repo_name)



<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
* [GitHub Emoji Cheat Sheet](https://www.webpagefx.com/tools/emoji-cheat-sheet)
* [Img Shields](https://shields.io)
* [Choose an Open Source License](https://choosealicense.com)
* [GitHub Pages](https://pages.github.com)
* [Animate.css](https://daneden.github.io/animate.css)
* [Loaders.css](https://connoratherton.com/loaders)
* [Slick Carousel](https://kenwheeler.github.io/slick)
* [Smooth Scroll](https://github.com/cferdinandi/smooth-scroll)
* [Sticky Kit](http://leafo.net/sticky-kit)
* [JVectorMap](http://jvectormap.com)
* [Font Awesome](https://fontawesome.com)





<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/othneildrew/Best-README-Template.svg?style=for-the-badge
[contributors-url]: https://github.com/othneildrew/Best-README-Template/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/othneildrew/Best-README-Template.svg?style=for-the-badge
[forks-url]: https://github.com/othneildrew/Best-README-Template/network/members
[stars-shield]: https://img.shields.io/github/stars/othneildrew/Best-README-Template.svg?style=for-the-badge
[stars-url]: https://github.com/othneildrew/Best-README-Template/stargazers
[issues-shield]: https://img.shields.io/github/issues/othneildrew/Best-README-Template.svg?style=for-the-badge
[issues-url]: https://github.com/othneildrew/Best-README-Template/issues
[license-shield]: https://img.shields.io/github/license/othneildrew/Best-README-Template.svg?style=for-the-badge
[license-url]: https://github.com/othneildrew/Best-README-Template/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/othneildrew
[product-screenshot]: images/screenshot.png
